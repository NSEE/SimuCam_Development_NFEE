#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "crc8.h"



int main()
{
    char buffer[128];
    unsigned char crc8;

    printf("Hello World");

    
    sprintf(buffer, "Ola buffer meu camarada");

    crc8 = ucCrc8wInit(buffer,strlen(buffer));
    
    printf("CRC: %hhu", crc8);
    
    return 0;
}


