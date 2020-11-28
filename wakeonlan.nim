import parseopt
import strutils
import net

var usage = """

Usage:
# wakeonlan -h:<ip> -m:<mac id>
"""

var host: string
var mac: string
var parser = initOptParser(shortNoVal = {}, longNoVal = @[])

for kind, key, val in parser.getopt():
  case kind
  of cmdLongOption, cmdShortOption:
    case key
    of "h": host = val 
    of "m": mac = val
  of cmdArgument: continue
  of cmdEnd: assert(false) # This should not occur

if host == "":
  echo "Host not provided"
  echo usage
  system.quit(1)

if mac == "":
  echo "Mac address not provided"
  echo usage
  system.quit(1)
else:
  mac = mac.replace(":")

if mac.len != 12:
  echo "Invalid Mac address"
  echo usage
  system.quit(1)

var socket = newSocket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
socket.sendTo(host, Port(9), '\xFF'.repeat(6) & mac.toHex.repeat(16))

echo "Magic Packet Sent!"
