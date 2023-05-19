import nmap
nm = nmap.PortScanner()
nm.scan('172.20.5.144')
for host in nm.all_hosts():
    print('----------------------------------------------------')
    print('Host : %s (%s)' % (host, nm[host].hostname()))
    print('State : %s' % nm[host].state())
    for proto in nm[host].all_protocols():
            print('----------')
            print('Protocol : %s' % proto)
            lport = nm[host][proto].keys()
            sorted(lport)
            for port in lport:
                    print ('port : %s\tstate : %s' % (port, nm[host][proto][port]['state']))
            print(nm.csv)