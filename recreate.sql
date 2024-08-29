DROP DATABASE commerce;

CREATE DATABASE commerce;

USE commerce;

DELIMITER |

SOURCE schema.sql|

DELIMITER ;

SOURCE q_test.sql;
