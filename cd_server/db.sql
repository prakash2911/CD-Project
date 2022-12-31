CREATE DATABASE cd ;
USE cd;

create table studentdetails(
    regno varchar(20),
    name varchar(50),
    course varchar(20),
    stream varchar(50),
    year int,
    primary key(regno)
);
INSERT INTO studentdetails VALUES("2020503515","JAYAPRAKASH S","BE","COMPUTER SCIENCE",3);
INSERT INTO studentdetails VALUES("2020503530","PRAKASH M","BE","COMPUTER SCIENCE",3);
INSERT INTO studentdetails VALUES("2020503510","GURURAMAN C","BE","COMPUTER SCIENCE",3);