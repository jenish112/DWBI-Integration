-- create database
create database test_db;

-- create schema
create schema test_db_Schema;

-- create our tables
create table DimDate(
    DateID int primary key,
    Date DATE,
    DAYOFWEEK varchar(10),
    Month varchar(10),
    Quarter int,
    Year int,
    Isweekend boolean
);

DROP TABLE DimDate;

create table DimLoyaltyProgram(
    LoyaltyProgramID int primary key,
    ProgramName varchar(100),
    ProgramTier varchar(50),
    PointsAccrued int
);

create OR REPLACE table DimCustomer(
    CustomerID int primary key autoincrement start 1 increment 1,
    FirstName varchar(100),
    LastName varchar(100),
    Gender varchar(100),
    DateOfBirth date,
    Email varchar(100),
    PhoneNumber varchar(100),
    Address varchar(100),
    City varchar(100),
    State varchar(100),
    Zipcode varchar(100),
    Country varchar(100),
    LoyaltyProgramID int
);

create OR REPLACE table DimProduct(
    ProductID int primary key autoincrement start 1 increment 1,
    ProductName varchar(100),
    Category varchar(50),
    Brand varchar(50),
    UnitPrice DECIMAL(10,2)
);

create OR REPLACE table DimStore(
    StoreID int primary key autoincrement start 1 increment 1,
    StoreName varchar(100),
    StoreType varchar(100),
    StoreOpeningDate Date,
    Address varchar(100),
    City varchar(100),
    State varchar(100),
    Country varchar(100),
    Region varchar(100),
    ManagerName varchar(100)
);

CREATE table FactOrders (
    OrderID int primary key autoincrement start 1 increment 1,
    DateID INT,
    CustomerID INT,
    ProductID INT,
    StoreID INT,
    QuantityOrdered INT,
    OrderAmount Decimal(10,2),
    DiscountAmount Decimal(10,2),
    ShippingCost Decimal(10,2),
    TotalAmount Decimal(10,2),
    FOREIGN key (DateID) references DimDate(DateID),
    FOREIGN key (CustomerID) references DimCustomer(CustomerID),
    FOREIGN key (ProductID) references DimProduct(ProductID),
    FOREIGN key (StoreID) references DimStore(StoreID)
);

Create or replace file format CSV_SOURCE_FILE_FORMAT
TYPE = 'CSV'
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
DATE_FORMAT = 'YYYY-MM-DD';


CREATE or replace STAGE TESTSTAGE;

-- PUT 'file:///Users/jenishvekariya/Desktop/Projects/Data Integration/DimLoyaltyInfo.csv' @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimLoyaltyInfo/ AUTO_COMPRESS=FALSE;
-- PUT 'file:///Users/jenishvekariya/Desktop/Projects/Data Integration/data_cust_v3.csv' @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimCustomerData/ AUTO_COMPRESS=FALSE;
-- PUT 'file:///Users/jenishvekariya/Desktop/Projects/Data Integration/DimProdData.csv' @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimProductData/ AUTO_COMPRESS=FALSE;
-- PUT 'file:///Users/jenishvekariya/Desktop/Projects/Data Integration/DimDate.csv' @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimDate/ AUTO_COMPRESS=FALSE;
-- PUT 'file:///Users/jenishvekariya/Desktop/Projects/Data Integration/DimStoreData.csv' @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimStoreData/ AUTO_COMPRESS=FALSE;
-- PUT 'file:///Users/jenishvekariya/Desktop/Projects/Data Integration/factorders.csv' @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/factorders/ AUTO_COMPRESS=FALSE;
-- PUT 'file:///Users/jenishvekariya/Desktop/Projects/Data Integration/Landing Directory/*.csv' @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/Landing_Directory/ AUTO_COMPRESS=FALSE;

copy INTO DimLoyaltyProgram from @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimLoyaltyInfo/DimLoyaltyInfo.csv
FILE_FORMAT =  (FORMAT_NAME = 'CSV_SOURCE_FILE_FORMAT')

select * from dimloyaltyprogram;

copy INTO DimCustomer (FirstName, LastName, Gender, DateOfBirth, Email, PhoneNumber, Address, City, State, Zipcode, Country, LoyaltyProgramID)
from @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimCustomerData/data_cust_v3.csv
FILE_FORMAT =  (FORMAT_NAME = 'CSV_SOURCE_FILE_FORMAT')

copy INTO DimProduct (ProductName, Category, Brand, UnitPrice)
from @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimProductData/DimProdData.csv
FILE_FORMAT =  (FORMAT_NAME = 'CSV_SOURCE_FILE_FORMAT')

COPY INTO DimDate (DateID, Date, DAYOFWEEK, month, QUARTER, year, ISWEEKEND)
from @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimDate/DimDate.csv
FILE_FORMAT =  (FORMAT_NAME = 'CSV_SOURCE_FILE_FORMAT')

copy INTO DIMSTORE (StoreName,StoreType, StoreOpeningDate, Address, City, State, Country, Region, ManagerName)
from @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/DimStoreData/DimStoreData.csv
FILE_FORMAT =  (FORMAT_NAME = 'CSV_SOURCE_FILE_FORMAT')

select * from dimstore;

copy INTO FactOrders(DateID, CustomerID, ProductID, StoreID, QuantityOrdered, OrderAmount, DiscountAmount, ShippingCost, TotalAmount)
from @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/factorders/factorders.csv
FILE_FORMAT =  (FORMAT_NAME = 'CSV_SOURCE_FILE_FORMAT')

copy INTO FactOrders(DateID, CustomerID, ProductID, StoreID, QuantityOrdered, OrderAmount, DiscountAmount, ShippingCost, TotalAmount)
from @TEST_DB.TEST_DB_SCHEMA.TESTSTAGE/Landing_Directory/
FILE_FORMAT =  (FORMAT_NAME = 'CSV_SOURCE_FILE_FORMAT')


-- create a new user
create or replace user Test_PowerBI_User
    PASSWORD = 'Test_PoweBI_User'
    LOGIN_NAME = 'PowerBI User'
    DEFAULT_ROLE = 'ACCOUNTADMIN'
    DEFAULT_WAREHOUSE = 'COMPUTE_WH'
    MUST_CHANGE_PASSWORD = TRUE


-- grant it accountadmin access
grant role accountadmin to user Test_PowerBI_User;
