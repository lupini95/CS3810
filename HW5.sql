CREATE DATABASE airline_booking;

\c airline_booking
-- Costumer Table with auto
-- generated primary key 'costumer_id'
CREATE TABLE costumers(
	costumer_id SERIAL PRIMARY KEY,
	last_name VARCHAR(100),
	first_name VARCHAR(100));

-- Countries Table
CREATE TABLE countries(
	country_name VARCHAR(100),
	country_code INT,
	country_abr VARCHAR(10),
	PRIMARY KEY (country_code));

-- States Table
CREATE TABLE states_provinces(
	state_province_name VARCHAR(225),
	state_province_abr VARCHAR(20),
	PRIMARY KEY (state_province_abr));

-- Cities Table
CREATE TABLE cities(
	city_name VARCHAR(100),
	city_code VARCHAR(10), --airport can use this, may be null
	state_province_abr VARCHAR(10) REFERENCES states_provinces(state_province_abr),
	country_code INT REFERENCES countries (country_code),
	CONSTRAINT pk_city PRIMARY KEY (city_name, state_province_abr, country_code));

-- Area_Codes Table
CREATE TABLE area_codes(
	city_name VARCHAR(100),
	state_province_abr VARCHAR(10),
	area_code INT,
	country_code INT,
	CONSTRAINT pk_area PRIMARY KEY (area_code, country_code),
	CONSTRAINT fk_area
		FOREIGN KEY (city_name, state_province_abr, country_code)
		REFERENCES cities(city_name, state_province_abr, country_code));

-- Postal_Codes Table
CREATE TABLE postal_codes(
	postal_code INT,
	city_name VARCHAR(100),
	state_province_abr VARCHAR(10),
	country_code INT,
	CONSTRAINT pk_postal PRIMARY KEY (postal_code,city_name),
	CONSTRAINT fk_postal
		FOREIGN KEY (city_name, state_province_abr, country_code)
		REFERENCES cities(city_name, state_province_abr, country_code));

-- Address Table
CREATE TABLE address(
	street_num INT NOT NULL,
	apt_num INT,
	street_name VARCHAR(225) NOT NULL,
	postal_code INT NOT NULL,
	city_name VARCHAR(100),
	CONSTRAINT pk_address PRIMARY KEY (street_num, apt_num, street_name, postal_code, city_name),
	CONSTRAINT fk_address 
		FOREIGN KEY (postal_code, city_name)
		REFERENCES postal_codes(postal_code, city_name));

-- Lives_At Relationship Table
CREATE TABLE lives_at(
	costumer_id INT REFERENCES costumers(costumer_id),
	street_num INT NOT NULL,
	apt_num INT,
	street_name VARCHAR(225) NOT NULL,
	postal_code INT NOT NULL,
	city_name VARCHAR(100),
	CONSTRAINT pk_lives_at 
		PRIMARY KEY (costumer_id, street_num, apt_num, street_name, postal_code, city_name),
	CONSTRAINT fk_lives_at 
		FOREIGN KEY (street_num, apt_num, street_name, postal_code, city_name)
		REFERENCES address(street_num, apt_num, street_name, postal_code, city_name));

-- Phone_Number Table
CREATE TABLE phone_number(
	country_code INT,
	area_code INT,
	local_num INT,
	CONSTRAINT pk_phone PRIMARY KEY (country_code, area_code, local_num),
	CONSTRAINT fk_phone 
		FOREIGN KEY (country_code, area_code)
		REFERENCES area_codes(country_code, area_code));

-- has_num Table
CREATE TABLE has_num(
	costumer_id INT REFERENCES costumers(costumer_id),
	country_code INT,
	area_code INT,
	local_num INT,
	CONSTRAINT pk_has_num PRIMARY KEY (costumer_id, area_code, local_num),
	CONSTRAINT fk_has_num 
		FOREIGN KEY (country_code, area_code, local_num)
		REFERENCES phone_number(country_code, area_code, local_num));

-- email table
CREATE TABLE email(
	costumer_id INT REFERENCES costumers(costumer_id),
	email VARCHAR(225),
	CONSTRAINT pk_email PRIMARY KEY (costumer_id, email));

-- airlines table
CREATE TABLE airlines(
	airline_name VARCHAR(25),
	country_abr VARCHAR(10),
	airline_code VARCHAR(10),
	PRIMARY KEY (airline_code));

-- travel_locations
CREATE TABLE travel_locations(
	city_name VARCHAR(100),
	state_province_abr VARCHAR(10) REFERENCES states_provinces(state_province_abr),
	country_code INT REFERENCES countries(country_code),
	city_code VARCHAR(10),
	PRIMARY KEY (city_code));

-- booking_locations
CREATE TABLE booking_locations(
	city_name VARCHAR(100),
	state_province_abr VARCHAR(10) REFERENCES states_provinces(state_province_abr),
	country_code INT REFERENCES countries(country_code),
	city_code VARCHAR(10),
	PRIMARY KEY (city_code));

-- flights table
CREATE TABLE flights(
	origin_city_code VARCHAR(10) REFERENCES travel_locations(city_code),
	dest_city_code VARCHAR(10) REFERENCES travel_locations(city_code),
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
	city_code VARCHAR(10) REFERENCES booking_locations(city_code),
	book_date DATE,
	payers_id INT REFERENCES costumers(costumer_id),
	unique_flight_num INT REFERENCES flights(unique_flight_num),
	PRIMARY KEY (booking_id));

-- tickets table
CREATE TABLE tickets(
	booking_id INT REFERENCES bookings(booking_id),
	passenger_id INT REFERENCES costumers(costumer_id),
	CONSTRAINT pk_ticket PRIMARY KEY (booking_id, passenger_id));


