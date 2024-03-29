version: 2
ethernets:
    ${interface}:
        addresses: 
        - ${ip_addr}/24
        dhcp4: false
        gateway4: 192.168.122.1
        match:
            macaddress: ${mac_addr}
        nameservers:
            addresses: 
            - 1.1.1.1
            - 8.8.8.8
        set-name: ${interface}
