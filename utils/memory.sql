/*
pga_aggregate_target:
  + memory_target > 0 && pga_aggregate_target = 0 -> Dynamic memory allocation by MEMORY parameter.
  + memory_target > 0 && pga
  + Without parameter - memory = 0: Says how much memory will be allocated to PGA.
  + With parameter    - memory > 0: Says how much memory will be allocated to PGA at first. It can grow dynamically.

sga_target:
  + Without parameter - memory = 0: Says how much memory will be allocated to PGA.
  + With parameter    - memory > 0:

sga_max_size:
  + Without parameter - memory = 0: Max memory size
  + With parameter    - memory > 0: Max memory size

memory_target:

memor_max_target:

*/
SHOW PARAMETER pga_aggregate_target

-- sga_max_size: Show max amount of memory it'll be allocated to PGA.
SHOW PARAMETER sga_max_size

/*
 * IF MEMORY_TARGET > 0 AND PGA_AGGREGATE_TARGET > 0 THEN PGA_AGGREGATE_TARGET acts as the minimum value for the size of the instance PGA.
 *
 */

IF MEMORY_TARGET > 0 THEN

  IF PGA_AGGREGATE_TARGET > 0 THEN

    DBMS_OUTPUT.PUT_LINE('PGA_AGGREGATE_TARGET acts as the minimum value for the size of the instance PGA.');

  END IF;

  IF SGA_TARGET > 0 THEN

    DBMS_OUTPUT.PUT_LINE('SGA_TARGET acts as the minimum value for the size of the instance SGA.');

  END IF;

  IF MEMORY_TARGET > MEMORY_MAX_TARGET

    RAISE EXCEPTION;

  END IF;

END IF;
