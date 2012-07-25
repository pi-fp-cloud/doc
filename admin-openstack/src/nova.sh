#!/bin/bash
SERVICIOS="libvirt-bin nova-cert nova-network nova-compute nova-api nova-objectstore nova-scheduler nova-volume nova-consoleauth novnc"

REVERSE="novnc nova-consoleauth nova-volume nova-scheduler nova-objectstore nova-api nova-compute nova-network nova-cert libvirt-bin"

function iniciarServiciosNova()
{
	/etc/init.d/rabbitmq-server start
	for servicio in $SERVICIOS
	do
		service $servicio start
	done
}

function pararServiciosNova()
{
	for servicio in $REVERSE
	do
		service $servicio stop
	done
	/etc/init.d/rabbitmq-server stop
}


case $1 in
	start)
		echo "Iniciando todos los servicios nova"
		iniciarServiciosNova
	;;

	stop)
		echo "Parando todos los servicios nova"
		pararServiciosNova
	;;

	restart)
		echo "Parando todos los servicios nova"
		pararServiciosNova
		echo "Iniciando todos los servicios nova"
		iniciarServiciosNova
	;;

	*) echo "Opción desconocida, uso $0 start|stop|restart"
	;;
esac


