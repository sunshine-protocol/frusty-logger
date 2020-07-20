#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>


/**
 * init the logger and return `0` if everything goes well, `1` in case it is already initialized.
 */
int32_t frusty_logger_init(int64_t port, void* post_c_object);

/**
 * Check if the Logger is already initialized to prevent any errors of calling init again.
 * return 1 if initialized before, 0 otherwise.
 */
int32_t frusty_logger_is_initialized(void);

void rand_log(void);
