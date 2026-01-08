#!/bin/zsh
# opencode-network-diag.sh
# Diagnoses and optionally fixes OpenCode network/mDNS issues

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Symbols
CHECK="${GREEN}✓${NC}"
WARN="${YELLOW}⚠${NC}"
CROSS="${RED}✗${NC}"

echo ""
echo -e "${BLUE}OpenCode Network Diagnostic${NC}"
echo "============================"
echo ""

# 1. Check if OpenCode serve is running
OPENCODE_PID=$(pgrep -f "opencode serve" | head -1 || true)
if [ -n "$OPENCODE_PID" ]; then
    # Find the port - look for LISTEN socket from this specific process
    PORT_INFO=$(lsof -iTCP -sTCP:LISTEN -P 2>/dev/null | grep "^opencode.*$OPENCODE_PID" | awk '{print $9}' | grep -oE '[0-9]+$' | head -1 || true)
    if [ -n "$PORT_INFO" ]; then
        PORT="$PORT_INFO"
    else
        # Fallback: check common opencode ports
        if lsof -i :4096 2>/dev/null | grep -q "$OPENCODE_PID"; then
            PORT="4096"
        else
            PORT="unknown"
        fi
    fi
    echo -e "${CHECK} OpenCode running (PID $OPENCODE_PID) on port $PORT"
else
    echo -e "${CROSS} OpenCode serve is not running"
    PORT=""
fi
echo ""

# 2. Check hostname configuration
LOCAL_HOSTNAME=$(scutil --get LocalHostName 2>/dev/null || echo "unknown")
COMPUTER_NAME=$(scutil --get ComputerName 2>/dev/null || echo "unknown")

echo "Hostname Configuration:"
if [[ "$LOCAL_HOSTNAME" =~ -[0-9]+$ ]]; then
    echo -e "  ${WARN} LocalHostName: ${YELLOW}$LOCAL_HOSTNAME${NC} (conflict suffix detected)"
    HOSTNAME_CONFLICT=true
else
    echo -e "  ${CHECK} LocalHostName: $LOCAL_HOSTNAME"
    HOSTNAME_CONFLICT=false
fi
echo "     ComputerName: $COMPUTER_NAME"
echo ""

# 3. List active network interfaces on local subnets
echo "Network Interfaces:"
INTERFACES=()
SUBNET_COUNT=()

# Parse ifconfig output more simply
CURRENT_IF=""
while IFS= read -r line; do
    # Check for interface line (starts with interface name, no leading whitespace)
    if [[ "$line" == [a-z]* && "$line" == *:* ]]; then
        CURRENT_IF=$(echo "$line" | cut -d: -f1)
    fi
    # Check for inet line
    if [[ "$line" == *"inet "* && "$line" != *"inet6"* ]]; then
        IP=$(echo "$line" | awk '{print $2}')
        # Skip localhost and non-private IPs
        if [[ "$IP" != "127.0.0.1" && ("$IP" == 192.168.* || "$IP" == 10.* || "$IP" == 172.*) ]]; then
            # Get interface description
            DESC=""
            case "$CURRENT_IF" in
                en0) DESC="(Wi-Fi)" ;;
                en1) DESC="(Ethernet)" ;;
                en*) DESC="(Network)" ;;
                bridge*) DESC="(Bridge)" ;;
                *) DESC="" ;;
            esac
            
            SUBNET=$(echo "$IP" | cut -d. -f1-3)
            echo "  $CURRENT_IF $DESC: $IP"
            INTERFACES+=("$CURRENT_IF:$IP")
            SUBNET_COUNT+=("$SUBNET")
        fi
    fi
done < <(ifconfig)
echo ""

# 4. Check for multiple interfaces on same subnet
MULTI_SUBNET=false
UNIQUE_SUBNETS=$(printf '%s\n' "${SUBNET_COUNT[@]}" | sort | uniq -d)
if [ -n "$UNIQUE_SUBNETS" ]; then
    MULTI_SUBNET=true
fi

if [ "$MULTI_SUBNET" = true ]; then
    echo -e "${WARN} ${YELLOW}Multiple interfaces on same subnet - may cause mDNS conflicts${NC}"
    echo ""
fi

# 5. Check mDNS advertising (if OpenCode is running)
if [ -n "$OPENCODE_PID" ]; then
    echo "mDNS Service:"
    # Check if this process has mDNS socket open (indicates --mdns flag)
    if lsof -p "$OPENCODE_PID" 2>/dev/null | grep -q "UDP.*mdns"; then
        # Try to get the advertised hostname
        MDNS_LOOKUP=$(mktemp)
        ( dns-sd -L "opencode-$PORT" _http._tcp local. > "$MDNS_LOOKUP" 2>/dev/null ) &
        MDNS_PID=$!
        sleep 2
        kill $MDNS_PID 2>/dev/null || true
        
        MDNS_HOST=$(grep "can be reached at" "$MDNS_LOOKUP" 2>/dev/null | sed 's/.*can be reached at //' | awk '{print $1}' | head -1)
        rm -f "$MDNS_LOOKUP"
        
        if [ -n "$MDNS_HOST" ]; then
            echo -e "  Advertising as: ${BLUE}$MDNS_HOST${NC}"
        else
            echo -e "  ${CHECK} mDNS enabled (opencode-$PORT)"
        fi
    else
        echo -e "  ${WARN} Not using --mdns flag"
    fi
    echo ""
fi

# 6. Test reachability
if [ -n "$PORT" ]; then
    echo "Reachability:"
    for iface in "${INTERFACES[@]}"; do
        IP=$(echo "$iface" | cut -d: -f2)
        if curl -s -o /dev/null -w "" --max-time 2 "http://$IP:$PORT/" 2>/dev/null; then
            echo -e "  ${CHECK} http://$IP:$PORT"
        else
            echo -e "  ${CROSS} http://$IP:$PORT (unreachable)"
        fi
    done
    echo ""
fi

# 7. Print recommended URLs
if [ -n "$PORT" ]; then
    echo -e "${BLUE}Access URLs:${NC}"
    for iface in "${INTERFACES[@]}"; do
        IP=$(echo "$iface" | cut -d: -f2)
        IF_NAME=$(echo "$iface" | cut -d: -f1)
        echo "  http://$IP:$PORT"
    done
    if [ -n "$MDNS_HOST" ]; then
        # Clean up hostname format (remove trailing dot if present)
        MDNS_URL=$(echo "$MDNS_HOST" | sed 's/\.:/:/g')
        if [ "$HOSTNAME_CONFLICT" = true ] || [ "$MULTI_SUBNET" = true ]; then
            echo -e "  http://$MDNS_URL ${YELLOW}(may change due to conflicts)${NC}"
        else
            echo "  http://$MDNS_URL"
        fi
    fi
    echo ""
fi

# 8. Handle --fix flag
if [ "$1" = "--fix" ]; then
    echo -e "${BLUE}Applying fixes...${NC}"
    echo ""
    
    # Extract base hostname (remove -N suffix)
    BASE_HOSTNAME=$(echo "$LOCAL_HOSTNAME" | sed 's/-[0-9]*$//')
    
    if [ "$HOSTNAME_CONFLICT" = true ]; then
        echo "Resetting hostname to '$BASE_HOSTNAME'..."
        sudo scutil --set LocalHostName "$BASE_HOSTNAME"
        echo -e "${CHECK} LocalHostName set to $BASE_HOSTNAME"
    fi
    
    echo "Flushing mDNS cache..."
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    echo -e "${CHECK} mDNS cache flushed"
    
    if [ -n "$OPENCODE_PID" ]; then
        echo "Restarting OpenCode serve..."
        pkill -f "opencode serve" || true
        sleep 1
        echo -e "${CHECK} OpenCode stopped (restart it manually with: opencode serve --mdns)"
    fi
    
    echo ""
    echo -e "${GREEN}Fixes applied!${NC} Re-run this script to verify."
elif [ "$HOSTNAME_CONFLICT" = true ] || [ "$MULTI_SUBNET" = true ]; then
    echo -e "Run with ${BLUE}--fix${NC} to attempt automatic repairs"
fi

echo ""
