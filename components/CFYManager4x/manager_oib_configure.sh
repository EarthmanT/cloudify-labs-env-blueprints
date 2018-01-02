#!/bin/bash

# install build
ctx logger info "Installing packages"
sudo yum -y install gcc python-devel wget

# configure route, now and permanently
ctx logger info "Setting Static routes"
sudo route add -net 192.168.113.0/24 gw 10.10.25.253
sudo /bin/bash -c "echo '192.168.113.0/24 via 10.10.25.253 dev br-ovs' >> /etc/sysconfig/network"

# generate Key
ctx logger info "Generating Keys"
sudo mkdir -p /etc/cloudify/.ssh/
sudo ssh-keygen -f /etc/cloudify/.ssh/cfy-agent-kp -N ""
sudo chown cfyuser:cfyuser -R /etc/cloudify/.ssh
publick_key=$(sudo cat /etc/cloudify/.ssh/cfy-agent-kp.pub)

env -i cfy status > /tmp/cfy_status.txt 2>&1

# create secrets
ctx logger info "Creating Secrests"
env -i cfy secret create ubuntu_trusty_image -s 05bb3a46-ca32-4032-bedd-8d7ebd5c8100 > /tmp/cfy_status.txt 2>&1
env -i cfy secret create centos_core_image -s aee5438f-1c7c-497f-a11e-53360241cf0f > /tmp/cfy_status.txt 2>&1

env -i cfy secret create small_image_flavor -s 4d798e17-3439-42e1-ad22-fb956ec22b54 > /tmp/cfy_status.txt 2>&1
#cfy secret create medium_image_flavor -s 62ed898b-0871-481a-9bb4-ac5f81263b33
env -i cfy secret create medium_image_flavor -s 3 > /tmp/cfy_status.txt 2>&1
env -i cfy secret create large_image_flavor -s 62ed898b-0871-481a-9bb4-ac5f81263b33 > /tmp/cfy_status.txt 2>&1

env -i cfy secret create keystone_username -s admin > /tmp/cfy_status.txt 2>&1
env -i cfy secret create keystone_password -s 'cloudify1234' > /tmp/cfy_status.txt 2>&1
env -i cfy secret create keystone_tenant_name -s admin > /tmp/cfy_status.txt 2>&1
env -i cfy secret create keystone_url -s http://10.10.25.1:5000/v2.0 > /tmp/cfy_status.txt 2>&1
env -i cfy secret create region -s RegionOne > /tmp/cfy_status.txt 2>&1

env -i cfy secret create agent_key_private -s /etc/cloudify/.ssh/cfy-agent-kp > /tmp/cfy_status.txt 2>&1
env -i cfy secret create agent_key_public --secret-file /etc/cloudify/.ssh/cfy-agent-kp.pub > /tmp/cfy_status.txt 2>&1

env -i cfy secret create private_subnet_name -s provider_subnet > /tmp/cfy_status.txt 2>&1
env -i cfy secret create private_network_name -s provider > /tmp/cfy_status.txt 2>&1
env -i cfy secret create public_subnet_name -s  private_subnet > /tmp/cfy_status.txt 2>&1
env -i cfy secret create public_network_name -s private_network > /tmp/cfy_status.txt 2>&1
env -i cfy secret create router_name -s router1 > /tmp/cfy_status.txt 2>&1
env -i cfy secret create external_network_name -s external_network > /tmp/cfy_status.txt 2>&1


# Upload Default Plugins
ctx logger info "Uploading Utilities"
env -i cfy plugins upload https://github.com/cloudify-incubator/cloudify-utilities-plugin/releases/download/1.2.5/cloudify_utilities_plugin-1.2.5-py27-none-linux_x86_64-centos-Core.wgn > /tmp/cfy_status.txt 2>&1
env -i cfy plugins upload https://github.com/cloudify-incubator/cloudify-utilities-plugin/releases/download/1.3.0/cloudify_utilities_plugin-1.3.0-py27-none-linux_x86_64-centos-Core.wgn > /tmp/cfy_status.txt 2>&1
env -i cfy plugins upload https://s3-eu-west-1.amazonaws.com/cloudify-release-eu/cloudify/wagons/cloudify-utilities-plugin/1.4.1/cloudify_utilities_plugin-1.4.1-py27-none-linux_x86_64-centos-Core.wgn > /tmp/cfy_status.txt 2>&1

#ctx logger info "Uploading Kubernetes"
#env -i cfy plugins upload https://github.com/cloudify-incubator/cloudify-kubernetes-plugin/releases/download/1.0.0/cloudify_kubernetes_plugin-1.0.0-py27-none-linux_x86_64.wgn > /tmp/cfy_status.txt 2>&1
#env -i cfy plugins upload https://github.com/cloudify-incubator/cloudify-kubernetes-plugin/releases/download/1.1.0/cloudify_kubernetes_plugin-1.1.0-py27-none-linux_x86_64-centos-Core.wgn > /tmp/cfy_status.txt 2>&1
#env -i cfy plugins upload https://github.com/cloudify-incubator/cloudify-kubernetes-plugin/releases/download/1.2.0/cloudify_kubernetes_plugin-1.2.0-py27-none-linux_x86_64-centos-Core.wgn > /tmp/cfy_status.txt 2>&1

ctx logger info "Uploading Diamond Plugins"
env -i cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-diamond-plugin/1.3.5/cloudify_diamond_plugin-1.3.5-py27-none-linux_x86_64-centos-Core.wgn > /tmp/cfy_status.txt 2>&1
env -i cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-diamond-plugin/1.3.5/cloudify_diamond_plugin-1.3.5-py27-none-linux_x86_64-Ubuntu-trusty.wgn > /tmp/cfy_status.txt 2>&1

ctx logger info "Uploading Fabric Plugins"
env -i cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-fabric-plugin/1.5/cloudify_fabric_plugin-1.5-py27-none-linux_x86_64-centos-Core.wgn > /tmp/cfy_status.txt 2>&1

ctx logger info "Uploading Openstack Plugins"
env -i cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-openstack-plugin/2.0.1/cloudify_openstack_plugin-2.0.1-py27-none-linux_x86_64-centos-Core.wgn > /tmp/cfy_status.txt 2>&1
env -i cfy plugins upload https://github.com/cloudify-cosmo/cloudify-openstack-plugin/releases/download/2.2.0/cloudify_openstack_plugin-2.2.0-py27-none-linux_x86_64-centos-Core.wgn > /tmp/cfy_status.txt 2>&1
env -i cfy plugins upload http://repository.cloudifysource.org/cloudify/wagons/cloudify-openstack-plugin/2.4.1.1/cloudify_openstack_plugin-2.4.1.1-py27-none-linux_x86_64-centos-Core.wgn > /tmp/cfy_status.txt 2>&1

ctx logger info "Script Ends"