/*
 * socket_debug_task.c
 *
 *  Created on: 27/11/2018
 *      Author: Tiago-Low
 *
 * Task that will manage the socket used for debug purposes
 */

#include "socket_debug_task.h"

/* Declarations for creating a task with TK_NEWTASK.
 * All tasks which use NicheStack (those that use sockets) must be created this way.
 * TK_OBJECT macro creates the static task object used by NicheStack during operation.
 * TK_ENTRY macro corresponds to the entry point, or defined function name, of the task.
 * inet_taskinfo is the structure used by TK_NEWTASK to create the task.
 */



void vSocketServerDebugTask( void *task_data ) {
	int fd_listen, max_socket;
	struct sockaddr_in addr;
	static SSSConn conn;
	fd_set readfds;

/*	 *Creating a file descriptor for a TCP Socket */
	if ((fd_listen = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"[socket_debug_task] Socket creation failed");
	}


/*
	 * Sockets primer, continued...
	 * Calling bind() associates a socket created with socket() to a particular IP
	 * port and incoming address. In this case we're binding to SSS_PORT and to
	 * INADDR_ANY address (allowing anyone to connect to us. Bind may fail for
	 * various reasons, but the most common is that some other socket is bound to
	 * the port we're requesting.
*/

	addr.sin_family = AF_INET;
	addr.sin_port = htons(xConfEth.siPortDebug);
	addr.sin_addr.s_addr = INADDR_ANY;

	if ((bind(fd_listen, (struct sockaddr * )&addr, sizeof(addr))) < 0) {
		alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"[socket_debug_task] Bind failed");
	}


/*	 * Sockets primer, continued...
	 * The listen socket is a socket which is waiting for incoming connections.
	 * This call to listen will block (i.e. not return) until someone tries to
	 * connect to this port.*/

	if ((listen(fd_listen, 1)) < 0) {
		alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE,
				"[socket_debug_task] Listen failed");
	}

/*	 At this point we have successfully created a socket which is listening
	 * on port for connection requests from any remote address.*/

	vResetConnection(&conn);
	printf("[socket_debug_task] Simple Socket Server listening on port %d\n", xConfEth.siPortDebug);

	bSetPainelLeds(LEDS_ON, LEDS_ST_1_MASK);

	while (1) {

/*		 * For those not familiar with sockets programming...
		 * The select() call below basically tells the TCPIP stack to return
		 * from this call when any of the events I have expressed an interest
		 * in happen (it blocks until our call to select() is satisfied).
		 *
		 * In the call below we're only interested in either someone trying to
		 * connect to us, or data being available to read on a socket, both of
		 * these are a read event as far as select is called.
		 *
		 * The sockets we're interested in are passed in in the readfds
		 * parameter, the format of the readfds is implementation dependant
		 * Hence there are standard MACROs for setting/reading the values:
		 *
		 *   FD_ZERO  - Zero's out the sockets we're interested in
		 *   FD_SET   - Adds a socket to those we're interested in
		 *   FD_ISSET - Tests whether the chosen socket is set*/

		FD_ZERO(&readfds);
		FD_SET(fd_listen, &readfds);
		max_socket = fd_listen + 1;

		if (conn.fd != -1) {
			FD_SET(conn.fd, &readfds);
			if (max_socket <= conn.fd) {
				max_socket = conn.fd + 1;
			}
		}

		select(max_socket, &readfds, NULL, NULL, NULL);


/*		 * If fd_listen (the listening socket we originally created in this thread
		 * is "set" in readfs, then we have an incoming connection request. We'll
		 * call a routine to explicitly accept or deny the incoming connection
		 * request (in this example, we accept a single connection and reject any
		 * others that come in while the connection is open).*/

		if (FD_ISSET(fd_listen, &readfds)) {
			vSocketHandleAccept(fd_listen, &conn);
		}

/*		 * If sss_handle_accept() accepts the connection, it creates *another*
		 * socket for sending/receiving data over sss. Note that this socket is
		 * independant of the listening socket we created above. This socket's
		 * descriptor is stored in conn.fd. If conn.fs is set in readfs... we have
		 * incoming data for our sss server, and we call our receiver routine
		 * to process it.*/

		else {
			if ((conn.fd != -1) && FD_ISSET(conn.fd, &readfds)) {
				vHandleReceive(&conn);
			}
		}
	}  while(1);
}


/*
 * vSocketHandleAccept()
 *
 * This routine is called when ever our listening socket has an incoming
 * connection request. Since this example has only data transfer socket,
 * we just look at it to see whether its in use... if so, we accept the
 * connection request and call the telent_send_menu() routine to transmit
 * instructions to the user. Otherwise, the connection is already in use;
 * reject the incoming request by immediately closing the new socket.
 *
 * We'll also print out the client's IP address.
 */

void vSocketHandleAccept(int listen_socket, SSSConn* conn) {
	int socket, len;
	struct sockaddr_in incoming_addr;

	len = sizeof(incoming_addr);

	if ((conn)->fd == -1) {
		if ((socket = accept(listen_socket, (struct sockaddr* )&incoming_addr,
				&len)) < 0) {
			alt_NetworkErrorHandler(EXPANDED_DIAGNOSIS_CODE,
					"[vSocketHandleAccept] accept failed");
		} else {
			(conn)->fd = socket;
			vDebugHello(conn);
			printf("[vSocketHandleAccept] accepted connection request from %s\n",
					inet_ntoa(incoming_addr.sin_addr));
		}
	} else {
		printf("[vSocketHandleAccept] rejected connection request from %s\n",
				inet_ntoa(incoming_addr.sin_addr));
	}
	return;
}

/*
 * vHandleReceive()
 *
 * This routine is called whenever there is a sss connection established and
 * the socket assocaited with that connection has incoming data. We will first
 * look for a newline "\n" character to see if the user has entered something
 * and pressed 'return'. If there is no newline in the buffer, we'll attempt
 * to receive data from the listening socket until there is.
 *
 * The connection will remain open until the user enters "Q\n" or "q\n", as
 * deterimined by repeatedly calling recv(), and once a newline is found,
 * calling sss_exec_command(), which will determine whether the quit
 * command was received.
 *
 * Finally, each time we receive data we must manage our receive-side buffer.
 * New data is received from the sss socket onto the head of the buffer,
 * and popped off from the beginning of the buffer with the
 * sss_exec_command() routine. Aside from these, we must move incoming
 * (un-processed) data to buffer start as appropriate and keep track of
 * associated pointers.
 */
void vHandleReceive(SSSConn* conn) {
	int data_used = 0, rx_code = 0;
	char *lf_addr;

	conn->rx_rd_pos = conn->rx_buffer;
	conn->rx_wr_pos = conn->rx_buffer;

	printf("[vHandleReceive] processing RX data\n");

	while (conn->state != CLOSE) {
		/* Find the Carriage return which marks the end of the header */
		lf_addr = strchr((const char*) conn->rx_buffer, '\n');

		if (lf_addr) {
			/* go off and do whatever the user wanted us to do */
			sss_exec_command(conn);
		}
		/* No newline received? Then ask the socket for data */
		else {
			rx_code = recv(conn->fd, (char* )conn->rx_wr_pos,
					SSS_RX_BUF_SIZE - (conn->rx_wr_pos - conn->rx_buffer) -1,
					0);

			if (rx_code > 0) {
				conn->rx_wr_pos += rx_code;

				/* Zero terminate so we can use string functions */
				*(conn->rx_wr_pos + 1) = 0;
			}
		}

		/*
		 * When the quit command is received, update our connection state so that
		 * we can exit the while() loop and close the connection
		 */
		conn->state = conn->close ? CLOSE : READY;

		/* Manage buffer */
		data_used = conn->rx_rd_pos - conn->rx_buffer;
		memmove(conn->rx_buffer, conn->rx_rd_pos,
				conn->rx_wr_pos - conn->rx_rd_pos);
		conn->rx_rd_pos = conn->rx_buffer;
		conn->rx_wr_pos -= data_used;
		memset(conn->rx_wr_pos, 0, data_used);
	}

	printf("[vHandleReceive] closing connection\n");
	close(conn->fd);
	vResetConnection(conn);

	return;
}

/*
 * vResetConnection()
 *
 * This routine will, when called, reset our SSSConn struct's members
 * to a reliable initial state. Note that we set our socket (FD) number to
 * -1 to easily determine whether the connection is in a "reset, ready to go"
 * state.
 */
void vResetConnection(SSSConn* conn) {
	memset(conn, 0, sizeof(SSSConn));

	conn->fd = -1;
	conn->state = READY;
	conn->rx_wr_pos = conn->rx_buffer;
	conn->rx_rd_pos = conn->rx_buffer;
	return;
}

void vDebugHello(SSSConn* conn) {
	char tx_buf[SSS_TX_BUF_SIZE];
	char *tx_wr_pos = tx_buf;

	tx_wr_pos += sprintf(tx_wr_pos, "=================================\n\r");
	tx_wr_pos += sprintf(tx_wr_pos, "Simucam Ethernet Debug Channel\n\r");
	tx_wr_pos += sprintf(tx_wr_pos, "=================================\n\r");

	send(conn->fd, tx_buf, tx_wr_pos - tx_buf, 0);

	return;
}
