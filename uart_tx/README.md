## What does it do?
This example is used to show how to communicate from the FPGA chip to your computer using a USB-C cable with the [UART protocol](https://en.wikipedia.org/wiki/Universal_asynchronous_receiver-transmitter).
Its sending out the character 'D' repeatedly all the time. If you press any keys on the keyboard, the output won't change because this example is just used to transmit to the PC, not to receive any data from the PC.

## Testing on Windows 
To check it, one should install PuTTY, it is used as a terminal emulator.
It's a completely free, open source sofware.
You can download PuTTY from the URL- https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
To download it from the given URL, just select the Package files from MSI(Windows Installer), depending on the computer you have. 
When you open PuTTY app after it's installed on your machine, just select the connection type as Serial, then you should check which 
COM port is working by taking a look in Device Manager ![WhatsApp Image 2024-12-29 at 02 43 53_3977c1b4](https://github.com/user-attachments/assets/ff155c72-e850-4397-81f0-21e0d7836902)
 of your computer. On our computer COM3 port was assigned to the FPGA board. Then select the required COM port and click open for PuTTY to start. 
Before running PuTTY one must disconnect the FPGA board from the Virtual box. But the FPGA must be physically connected with the computer
with the USB cable.
The ouptut 'D" should appear in the PuTTY like shown in the image below.
![WhatsApp Image 2024-12-28 at 23 53 37_0b86834c](https://github.com/user-attachments/assets/d55256ff-2a23-4e0c-a19f-be0eca765059)

## Testing on Linux terminal
Connect the FPGA board to the Virtual box.
Install picocom in the Linux terminal by running command ```apt install picocom```
Then use the command ```make terminal``` to run the picocom. It will start displaying the output 'D' in the terminal. 
To exit and stop, use ```Ctrl A+X```

## How does it work?
The UART protocol is implemented im the module uart_trx.v file.
It works in one direction only, ie. it sends data without having a provison to receive the data back from the receiver. 
For UART to work, the Baud rate shoud be the same on both the transmitting anf receiving side. Here the Baud rate is 9600 Hz.
