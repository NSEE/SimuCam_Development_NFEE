/*
 * logger_manager_simucam.h
 *
 *  Created on: 21/10/2018
 *      Author: TiagoLow
 */

#ifndef LOGGER_MANAGER_SIMUCAM_H_
#define LOGGER_MANAGER_SIMUCAM_H_


#include "../simucam_definitions.h"
#include "communication_utils.h"


bool bLogWriteSDCard ( const char * cDataIn, const char * cFilename );
void vLogWriteNUC ( const char * cDataIn );


#endif /* LOGGER_MANAGER_SIMUCAM_H_ */
