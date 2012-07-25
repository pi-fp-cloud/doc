#!/bin/bash

# Solo hay que modificar estos parámetros
PASSWORD=calex2010!!
EMAIL=alex@iescierva.net
PUBLIC_IP=172.20.254.190
PRIVATE_IP=172.20.253.190
ADMIN_IP=172.20.253.190

# Creación de tenants, usuarios y roles

keystone tenant-create --name admin
keystone tenant-create --name service

keystone user-create --name admin --pass $PASSWORD --email $EMAIL
keystone user-create --name nova --pass $PASSWORD --email $EMAIL
keystone user-create --name glance --pass $PASSWORD --email $EMAIL
keystone user-create --name swift --pass $PASSWORD --email $EMAIL

keystone role-create --name admin
keystone role-create --name Member

ADMIN_TENANT=`keystone tenant-list | grep admin | tr -d " " | awk -F \| ' { print $2 }'`
SERVICE_TENANT=`keystone tenant-list | grep service | tr -d " " | awk -F \| ' { print $2 }'`

ADMIN_ROLE=`keystone role-list | grep admin | tr -d " " | awk -F \| ' { print $2 }'`
MEMBER_ROLE=`keystone role-list | grep Member | tr -d " " | awk -F \| ' { print $2 }'`

ADMIN_USER=`keystone user-list | grep admin | tr -d " " | awk -F \| ' { print $2 }'`

# Añadimos el rol admin al usuario admin en el tenant admin
keystone user-role-add --user $ADMIN_USER --role $ADMIN_ROLE --tenant_id $ADMIN_TENANT

# Añadimos los roles de admin a los usuarios nova, glance y swift en el tenant service.
USERS=`keystone user-list | grep True | grep -v admin | tr -d " " | awk -F \| ' { print $2 } '`

for USER_ID in $USERS
do
    keystone user-role-add --user $USER_ID --role $ADMIN_ROLE --tenant_id $SERVICE_TENANT
done

# Añadimos también el rol Member al usuario admin en el tenant admin
keystone user-role-add --user $ADMIN_USER --role $MEMBER_ROLE --tenant_id $ADMIN_TENANT

# Creamos los servicios
keystone service-create --name nova --type compute --description "OpenStack Compute Service"
keystone service-create --name volume --type volume --description "OpenStack Volume Service"
keystone service-create --name glance --type image --description "OpenStack Image Service"
keystone service-create --name swift --type object-store --description "OpenStack Storage Service"
keystone service-create --name keystone --type identity --description "OpenStack Identity Service"
keystone service-create --name ec2 --type ec2 --description "OpenStack EC2 Service"

# Creamos los endpoints
for service in nova volume glance swift keystone ec2
do
    ID=`keystone service-list | grep $service | tr -d " " | awk -F \| ' { print $2 } '`
    case $service in
    "nova"     ) keystone endpoint-create --region myregion --service_id $ID \
                 --publicurl   "http://$PUBLIC_IP"':8774/v2/$(tenant_id)s' \
                 --adminurl    "http://$ADMIN_IP"':8774/v2/$(tenant_id)s' \
                 --internalurl "http://$PRIVATE_IP"':8774/v2/$(tenant_id)s'
    ;;
    "volume"   ) keystone endpoint-create --region myregion --service_id $ID \
                 --publicurl   "http://$PUBLIC_IP"':8776/v1/$(tenant_id)s' \
                 --adminurl    "http://$ADMIN_IP"':8776/v1/$(tenant_id)s' \
                 --internalurl "http://$PRIVATE_IP"':8776/v1/$(tenant_id)s'            
    ;;
    "glance"   ) keystone endpoint-create --region myregion --service_id $ID \
                 --publicurl   "http://$PUBLIC_IP"':9292/v1' \
                 --adminurl    "http://$ADMIN_IP"':9292/v1' \
                 --internalurl "http://$PRIVATE_IP"':9292/v1'
    ;;
    "swift"    ) keystone endpoint-create --region myregion --service_id $ID \
                 --publicurl   "http://$PUBLIC_IP"':8080/v1/AUTH_$(tenant_id)s' \
                 --adminurl    "http://$ADMIN_IP"':8080/v1' \
                 --internalurl "http://$PRIVATE_IP"':8080/v1/AUTH_$(tenant_id)s'
    ;;
    "keystone" ) keystone endpoint-create --region myregion --service_id $ID \
                 --publicurl   "http://$PUBLIC_IP"':5000/v2.0' \
                 --adminurl    "http://$ADMIN_IP"':35357/v2.0' \
                 --internalurl "http://$PRIVATE_IP"':5000/v2.0'
    ;;
    "ec2"      ) keystone endpoint-create --region myregion --service_id $ID \
                 --publicurl   "http://$PUBLIC_IP"':8773/services/Cloud' \
                 --adminurl    "http://$ADMIN_IP"':8773/services/Admin' \
                 --internalurl "http://$PRIVATE_IP"':8773/services/Cloud'
    ;;
    esac
done
