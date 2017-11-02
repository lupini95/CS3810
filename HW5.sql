CREATE DATABASE airline_booking;

\c airline_booking

-- countries table
CREATE TABLE countries(
	country_name VARCHAR(100) UNIQUE,
	country_code INT,
	country_abr VARCHAR(10) UNIQUE,
	PRIMARY KEY (country_abr));

-- airlines table
CREATE TABLE airlines(
	airline_name VARCHAR(100) UNIQUE,
	country_abr VARCHAR(10) REFERENCES countries(country_abr),
	airline_code VARCHAR(10),
	PRIMARY KEY (airline_code));

-- Cities Table
CREATE TABLE cities(
	city_name VARCHAR(100),
	state_province_name VARCHAR(100) UNIQUE,
	city_code VARCHAR(10) UNIQUE, --airport can use this, may be null
	country_abr VARCHAR(10) REFERENCES countries(country_abr),
	CONSTRAINT pk_city PRIMARY KEY (city_name, state_province_name));

-- costumer table
CREATE TABLE costumers(
	costumer_id SERIAL PRIMARY KEY,
	last_name VARCHAR(100),
	first_name VARCHAR(100),
	phone VARCHAR(11));

-- Address Table
CREATE TABLE address(
	street_num INT,
	street_name VARCHAR(225),
	city_name VARCHAR(100),
	state_province_name VARCHAR(100),
	postal_code INT,
	CONSTRAINT pk_address
		PRIMARY KEY (street_num, street_name, city_name, state_province_name),
	CONSTRAINT fk_address 
		FOREIGN KEY (city_name, state_province_name)
		REFERENCES cities(city_name, state_province_name));

-- Lives_At Relationship Table
CREATE TABLE lives_at(
	costumer_id INT REFERENCES costumers(costumer_id),
	street_num INT,
	street_name VARCHAR(225),
	city_name VARCHAR(100),
	state_province_name VARCHAR(100),
	CONSTRAINT pk_lives_at 
		PRIMARY KEY (costumer_id, street_num, street_name, city_name, state_province_name),
	CONSTRAINT fk_lives_at 
		FOREIGN KEY (street_num, street_name, city_name, state_province_name)
		REFERENCES address(street_num, street_name, city_name, state_province_name));

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

-- routes table
CREATE TABLE routes(
	airline_code VARCHAR(10) REFERENCES airlines(airline_code),
	origin_city_code VARCHAR(100) REFERENCES cities(city_code),
	dest_city_code VARCHAR(100) REFERENCES cities(city_code),
	CONSTRAINT pk_routes PRIMARY KEY (airline_code, origin_city_code, dest_city_code));

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

