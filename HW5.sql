CREATE DATABASE airline_booking;

\c airline_booking

-- countries table
CREATE TABLE countries(
	country_name VARCHAR(100) UNIQUE,
	country_code INT UNIQUE,
	country_abr VARCHAR(10) UNIQUE,
	PRIMARY KEY (country_abr));

-- airlines table
CREATE TABLE airlines(
	airline_name VARCHAR(25),
	country_abr VARCHAR(10) REFERENCES countries(country_abr),
	airline_code VARCHAR(10),
	PRIMARY KEY (airline_code));

-- States Table
CREATE TABLE states_provinces(
	state_province_name VARCHAR(225) UNIQUE,
	state_province_abr VARCHAR(20) UNIQUE,
	PRIMARY KEY (state_province_abr));

-- Cities Table
CREATE TABLE cities(
	city_name VARCHAR(100),
	city_code VARCHAR(10) UNIQUE, --airport can use this, may be null
	state_province_abr VARCHAR(10) REFERENCES states_provinces(state_province_abr),
	country_abr VARCHAR(10) REFERENCES countries(country_abr),
	CONSTRAINT pk_city PRIMARY KEY (city_name, state_province_abr));

-- area code table
CREATE TABLE area_code(
	area_code INT PRIMARY KEY,
	state_province_abr VARCHAR(20) REFERENCES states_provinces(state_province_abr));

-- Phone_Number Table
CREATE TABLE phone_number(
	full_num VARCHAR(11) PRIMARY KEY,
	country_code INT REFERENCES countries(country_code),
	area_code INT REFERENCES area_code(area_code), 
	local_num INT);

-- costumer table
CREATE TABLE costumers(
	costumer_id SERIAL PRIMARY KEY,
	last_name VARCHAR(100),
	first_name VARCHAR(100),
	phone VARCHAR(11) REFERENCES phone_number(full_num));

-- Address Table
CREATE TABLE address(
	street_num INT,
	street_name VARCHAR(225),
	city_name VARCHAR(100),
	state_province_abr VARCHAR(10),
	postal_code INT,
	CONSTRAINT pk_address
		PRIMARY KEY (street_num, street_name, city_name, state_province_abr),
	CONSTRAINT fk_address 
		FOREIGN KEY (city_name, state_province_abr)
		REFERENCES cities(city_name, state_province_abr));

-- Lives_At Relationship Table
CREATE TABLE lives_at(
	costumer_id INT REFERENCES costumers(costumer_id),
	street_num INT,
	street_name VARCHAR(225),
	city_name VARCHAR(100),
	state_province_abr VARCHAR(10),
	CONSTRAINT pk_lives_at 
		PRIMARY KEY (costumer_id, street_num, street_name, city_name, state_province_abr),
	CONSTRAINT fk_lives_at 
		FOREIGN KEY (street_num, street_name, city_name, state_province_abr)
		REFERENCES address(street_num, street_name, city_name, state_province_abr));

-- flights table
CREATE TABLE flights(
	origin_city_code VARCHAR(10) REFERENCES cities(city_code),
	dest_city_code VARCHAR(10) REFERENCES cities(city_code),
	unique_flight_num INT,
	airline_code VARCHAR(10) REFERENCES airlines(airline_code),
	flight_length TIME(0),
	flight_num INT,
	depart_date_time TIMESTAMP,
	arrival_date_time TIMESTAMP,
	PRIMARY KEY (unique_flight_num));

-- bookings table
CREATE TABLE bookings(
	booking_id INT,
	city_code VARCHAR(10) REFERENCES cities(city_code),
	book_date DATE,
	payers_id INT REFERENCES costumers(costumer_id),
	unique_flight_num INT REFERENCES flights(unique_flight_num),
	PRIMARY KEY (booking_id));

-- tickets table
CREATE TABLE tickets(
	booking_id INT REFERENCES bookings(booking_id),
	passenger_id INT REFERENCES costumers(costumer_id),
	CONSTRAINT pk_ticket PRIMARY KEY (booking_id, passenger_id));
