--CREATE DATABASE
if not EXISTS(select * from sys.databases where name = 'project')
    CREATE database project
GO
use project


--DOWN
--DROPPING CONSTRAINTS
if EXISTS(select * from information_schema.table_constraints 
    where constraint_name = 'fk_suggestions_suggestion_user_id')
    alter TABLE suggestions drop CONSTRAINT fk_suggestions_suggestion_user_id
if EXISTS(select * from information_schema.table_constraints
    where constraint_name = 'fk_staffs_staff_manager_id')
    alter TABLE staffs drop CONSTRAINT fk_staffs_staff_manager_id
if EXISTS(select * from information_schema.table_constraints
    where constraint_name = 'fk_categories_category_chapel_id')
    ALTER TABLE categories drop CONSTRAINT fk_categories_category_chapel_id
if EXISTS(select * from information_schema.table_constraints
    where constraint_name = 'fk_products_product_category_code')
    ALTER TABLE products drop CONSTRAINT fk_products_product_category_code
if EXISTS(select * from information_schema.table_constraints
    where constraint_name = 'fk_products_product_order_number')
    ALTER TABLE products drop CONSTRAINT fk_products_product_order_number
if EXISTS(select * from information_schema.table_constraints
    where constraint_name = 'fk_suppliers_supplier_order_number')
    ALTER TABLE suppliers drop CONSTRAINT fk_suppliers_supplier_order_number
if EXISTS(select * from information_schema.table_constraints
    where constraint_name = 'fk_payments_payment_order_number')
    ALTER TABLE payments drop CONSTRAINT fk_payments_payment_order_number

--DROPPING TABLES
DROP TABLE if EXISTS payments
DROP TABLE if EXISTS suppliers
DROP TABLE if EXISTS products
DROP TABLE if EXISTS orders
DROP TABLE if EXISTS categories
DROP TABLE if EXISTS staffs
DROP TABLE if EXISTS volunteers
DROP TABLE if EXISTS suggestions
DROP TABLE if EXISTS managers
DROP TABLE if EXISTS chapels
DROP TABLE if EXISTS users

--DROPPING STORED PROCEDURE
drop PROCEDURE if EXISTS c_upsert_products
drop PROCEDURE if EXISTS order_upsert

--UP 
GO
CREATE TABLE users (
    user_id int IDENTITY not null,
    user_firstname VARCHAR(50) not null,
    user_lastname VARCHAR(50) not null,
    user_email VARCHAR(50) not null,
    user_password VARCHAR(20) not null,
    user_confirm_passowrd VARCHAR(20) not null,
    user_apartment_number CHAR(5) not null,
    user_street_name VARCHAR(15) not null,
    user_city VARCHAR(20) not null,
    user_postal_code VARCHAR(10) not null,
    user_country VARCHAR(15) not null,
    user_phone_number VARCHAR(10) not null,
    user_date_of_birth VARCHAR(15) null,
    CONSTRAINT
        pk_users_user_id PRIMARY KEY(user_id),
    CONSTRAINT
        u_users_user_email UNIQUE(user_email),
    CONSTRAINT 
        u_users_confirm_password UNIQUE(user_confirm_passowrd)
)
GO
insert into users 
                    (user_firstname, 
                    user_lastname, user_email,
                    user_password, 
                    user_confirm_passowrd, 
                    user_apartment_number,
                    user_street_name, 
                    user_city,
                    user_postal_code,
                    user_country,
                    user_phone_number)
VALUES 
        ('Priya', 'Rao', 'priya@gmail.com', 'xyz', 'xyz', 'NY100', 'Greenwood', 'Syracuse', 13210, 'USA', 3152292345),
        ('Ayushi', 'Joshi', 'ayushi@gmail.com', 'abc', 'abc', 'NY100', 'Greenwood', 'Syracuse', 13210, 'USA', 3152292312),
        ('Shweta', 'Rane', 'shweta@gmail.com', 'pqr', 'pqr', 'NY101', 'Ackerman', 'Syracuse', 13210, 'USA', 3152292311),
        ('Rohit', 'Patel', 'rohit@gmail.com', 'mnc', 'mnc', 'NY102', 'Maryland', 'Syracuse', 13210, 'USA', 3153592345),
        ('Vivek', 'Shah', 'viveka@gmail.com', 'trs', 'tsr', 'NY103', 'Maryland', 'Syracuse', 13210, 'USA', 3152289345)
GO
CREATE TABLE chapels(
    chapel_id int IDENTITY not null,
    chapel_name VARCHAR(50) not null,
    chapel_street VARCHAR(20) not null,
    chapel_city VARCHAR(20) not null,
    chapel_region VARCHAR(20) not null,
    chapel_postal_code VARCHAR(20) not null,
    chapel_country VARCHAR(20) not null,
    CONSTRAINT
        pk_chapels_chapel_id PRIMARY KEY(chapel_id)
)
insert into chapels 
                    (chapel_name, 
                   chapel_street, 
                   chapel_city, 
                   chapel_region, 
                   chapel_postal_code, 
                   chapel_country)

VALUES 
        ('Easy Essentials', 'University Area', 'Syracuse', 'Central Area', 13210, 'USA');
GO
CREATE TABLE managers (
    manager_id int IDENTITY not null,
    manager_firstname VARCHAR(50) not null,
    manager_lastname varchar(50) not null,
    manager_email VARCHAR(20) not null,
    manager_password VARCHAR(20) not null,
    manager_confirm_password VARCHAR(20) not null,
    manager_street_name VARCHAR(20) not null,
    manager_city VARCHAR(20) not null,
    manager_postal_code VARCHAR(10) not null,
    manager_country VARCHAR(15) not null,
    manager_phone_number VARCHAR(10) not null,
    manager_date_of_birth VARCHAR(15) null,
    CONSTRAINT 
        pk_managers_manager_id PRIMARY KEY(manager_id),
    CONSTRAINT
        u_managers_manager_email UNIQUE(manager_email),
    CONSTRAINT
        u_managers_manager_confirm_password UNIQUE(manager_confirm_password)
)
insert into managers 
                    (manager_firstname, 
                      manager_lastname, 
                      manager_email, 
                      manager_password, 
                      manager_confirm_password, 
                      manager_street_name, 
                      manager_city, 
                      manager_postal_code, 
                      manager_country, 
                      manager_phone_number)
VALUES 
        ('Josh', 'Smith', 'josh@gmail.com', 'xyz', 'xyz','Redfield', 'Syracuse', 13210, 'USA', 3152288345),
        ('Monica', 'Jonas', 'monica@gmail.com', 'abc', 'abc', 'Redfield', 'Syracuse', 13210, 'USA', 3151588345)
GO
CREATE TABLE suggestions (
    suggestion_id int IDENTITY not null,
    suggestion_ticket_id VARCHAR(10) not null,
    suggestion_description VARCHAR(50) not null,
    suggestion_date DATE not null,
    suggestion_time TIME not null,
    suggestion_day VARCHAR(10) not null,
    suggestion_user_id int not null,
    CONSTRAINT
        pk_suggestions_suggestion_id PRIMARY KEY (suggestion_id),
    CONSTRAINT
        u_suggestions_suggestion_ticket_id UNIQUE (suggestion_ticket_id)
    
)
ALTER TABLE suggestions 
    ADD CONSTRAINT fk_suggestions_suggestion_user_id FOREIGN KEY(suggestion_user_id)
    REFERENCES users(user_id)

INSERT INTO suggestions 
                        (suggestion_ticket_id,
                         suggestion_description, 
                         suggestion_date, 
                         suggestion_time, 
                         suggestion_day, 
                         suggestion_user_id)

VALUES 
        ('SUTN007','Track all product information', '2022-08-11','05:00:00','Tuesday', 1 ),
        ('SUTN098','Audit your inventory', '2022-05-10','06:00:00','Monday', 2 ),
        ('SUTN100','Monitor the stock daily', '2022-08-11','05:00:00','Tuesday', 1 )

GO
CREATE TABLE volunteers (
    volunteer_id int IDENTITY not null,
    volunteer_firstname VARCHAR(50) not null,
    volunteer_lastname VARCHAR(50) not null,
    volunteer_willingness char(2) not null,
    volunteer_date DATE not null,
    volunteer_starttime time not null,
    volunteer_endtime time not null,
    volunteer_day VARCHAR(10) not null,
    CONSTRAINT
        pk_volunteers_volunteer_id PRIMARY KEY(volunteer_id)
)
insert into volunteers 
                        (volunteer_firstname, 
                        volunteer_lastname, 
                        volunteer_willingness, 
                        volunteer_date, 
                        volunteer_starttime, 
                        volunteer_endtime,
                        volunteer_day)
VALUES 
        ('Ash', 'Green','Y', '2021-05-22', '08:00:00','09:05:00', 'Monday'),
        ('Emma', 'Roy','N', '2022-03-07', '9:5:0','10:05:00', 'Saturday')

GO
CREATE TABLE staffs (
    staff_id int IDENTITY not null,
    staff_firstname VARCHAR(20) not null,
    staff_lastname VARCHAR(20) not null,
    staff_email VARCHAR(30) not null,
    staff_phone_number VARCHAR(10) not null,
    staff_streetname VARCHAR(20) not null,
    staff_city VARCHAR(20) not null,
    staff_postal_code VARCHAR(20) not null,
    staff_country VARCHAR(20) not null,
    staff_manager_id int not null
    CONSTRAINT
        pk_staffs_staff_id PRIMARY KEY (staff_id),
    CONSTRAINT
        u_staffs_staff_email UNIQUE (staff_email)
)
ALTER TABLE staffs
    ADD CONSTRAINT staffs_staff_manager_id FOREIGN KEY(staff_manager_id)
        REFERENCES managers(manager_id)
insert into staffs 
                    (staff_firstname, 
                    staff_lastname, 
                    staff_phone_number, 
                    staff_streetname, 
                    staff_city, 
                    staff_postal_code, 
                    staff_country, 
                    staff_email,
                    staff_manager_id)

 values 
        ('Robert', 'Brown', 3152456478, 'Ackerman', 'Syracuse', 13210, 'USA', 'robert@gmail.com',1),
        ('Namrata', 'Patel', 3152566478, 'Lancaster', 'Syracuse', 13210, 'USA', 'namrata@gmail.com',2),
        ('Suyog', 'Mane', 3151156478, 'Greenwood', 'Syracuse', 13210, 'USA', 'suyog@gmail.com',1),
        ('Sharavari', 'Khairnar', 3152489478, 'Ackerman', 'Syracuse', 13210, 'USA', 'sharavri@gmail.com',1),
        ('David', 'Bing', 3151156478, 'Lancaster', 'Syracuse', 13210, 'USA', 'david@gmail.com',2),
        ('Joey', 'King', 3152458878, 'Maryland', 'Syracuse', 13210, 'USA', 'joeyt@gmail.com',1),
        ('Taniya', 'Shah', 3151556478, 'Ackerman', 'Syracuse', 13210, 'USA', 'taniya@gmail.com',1),
        ('Mohit', 'Chavan', 3152456422, 'Maryland', 'Syracuse', 13210, 'USA', 'mohitt@gmail.com',1),
        ('Rachel','Tayor' , 3152457778, 'Greenwood', 'Syracuse', 13210, 'USA', 'rachel@gmail.com',2),
        ('Kenny', 'Smith', 3152336478, 'Ackerman', 'Syracuse', 13210, 'USA', 'kenny@gmail.com',1)

GO
CREATE TABLE categories (
    category_code CHAR(3) not null,
    category_name VARCHAR(50) not null,
    category_description VARCHAR(120) not null,
    category_chapel_id int not null,
    CONSTRAINT 
        pk_categories_category_code PRIMARY KEY (category_code)
)
ALTER TABLE categories 
    ADD CONSTRAINT fk_categories_category_chapel_id FOREIGN KEY(category_chapel_id)
        REFERENCES chapels(chapel_id)

insert into categories (
                        category_code,
                        category_name, 
                        category_description, 
                        category_chapel_id)

 values
        ('FR1', 'Fruits', 'Each type of fruit brings its own unique set of nutrients and benefits to the table.',1 ),
        ('VG1', 'Vegetables', 'Vegetables are parts of plants that are consumed by humans or other animals as food',1 ),
        ('GR1', 'Grains', 'Grains are the seeds of grass-like plants called cereals',1 ),
        ('PR1', 'Proteins', 'Proteins are large, complex molecules that play many critical roles in the body',1 ),
        ('DR1', 'Dairy Products', 'Dairy products are derived from milk, which has been an important source of nutrition for people',1 )
GO
CREATE TABLE orders(
    order_number int IDENTITY(200,1) not null,
    order_name VARCHAR(25) not null,
    order_quantity int not null,
    order_subtotal int not null,
    order_tax int not null,
    order_totalprice int not null,
    order_date DATE not null,
    order_details VARCHAR(100) not null,
    CONSTRAINT 
        pk_orders_order_id PRIMARY KEY (order_number)
)
insert into orders (
                    order_name, 
                    order_quantity, 
                    order_subtotal,
                    order_tax,
                    order_totalprice,
                    order_date, 
                    order_details)

    values  
            ('Apples', 10, 300,6,306, '2021-12-05', 'Ordered 10 apples'),
            ('Oranges', 5, 250, 2,252,'2021-11-13', 'Ordered 5 oranges'),   
            ('Tomatoes', 8, 16,1,17, '2020-11-25', 'Ordered 8 tomatoes'),
            ('Potatoes', 2, 20, 1,21,'2020-06-03', 'Ordered 1 potato'),
            ('Wheat', 3, 16.20, 2,18.20,'2020-05-04', 'Ordered 3 wheat'),
            ('Rice', 9, 30.60,5,35.60, '2021-05-13', 'Ordered 9 rice'),
            ('Meat', 11, 66,1,67, '2020-05-04', 'Ordered 11 meat'),
            ('Eggs', 6, 48,1,49, '2020-05-04', 'Ordered 6 eggs'),
            ('Butter', 10, 90,4,94, '2020-03-01', 'Ordered 10 butter'),
            ('Cheese', 10, 80,2,82, '2020-03-01', 'Ordered 15 cheese'),
            ('Guava', 12, 480, 2, 482, '2021-12-12', 'Ordered 12 guava'),
            ('Cherry', 13, 260, 7, 267, '2021-11-02', 'Ordered 13 cherry'),
            ('Bell Pepper', 8, 40, 8, 48, '2022-10-02', 'Ordered 8 bell pepper'),
            ('Peas', 9, 72, 2, 74, '2022-03-02', 'Ordered 9 peas'),
            ('Oats', 20,100,1,101,'2021-02-01', 'Ordered 20 oats'),
            ('Barley', 8, 48, 2,50,'2021-01-01', 'Ordered 8 barley'),
            ('Cereals', 5, 15,2,17,'2022-05-08', 'Ordered 5 cereals'),
            ('Nuts', 6, 30,5, 35,'2021-09-08', 'Ordered 6 nuts'),
            ('Beans', 8, 56,9, 63,'2020-11-12', 'Ordered 8 beans'),
            ('Tofu', 10, 80,2, 82,'2020-10-11', 'Ordered 10 beans'),
            ('Yogurt', 18, 108,1, 109,'2020-12-12', 'Ordered 18 yogurt'),
            ('Milk', 5, 45,5, 50,'2020-01-05', 'Ordered 5 milk'),
            ('Ice Cream', 2, 14,2, 16,'2021-08-09', 'Ordered 2 ice creams'),
            ('Mangoes', 4, 260, 5, 265, '2021-05-11', 'Ordered 4 mangoes'),
            ('Carrot', 10, 30, 3, 33, '2021-05-12', 'Ordered 10 carrots'),
            ('Apples', 11, 330, 3, 333, '2021-03-12', 'Ordered 11 apples'),
            ('Apples', 20, 600, 0, 600, '2021-06-12', 'Ordered 20 apples'),
            ('Ice Cream', 1, 7,2, 9,'2021-09-09', 'Ordered 1 ice cream'),
            ('Ice Cream', 40, 280,2, 282,'2022-02-14', 'Ordered 40 ice creamw')
GO
CREATE TABLE products (
    product_code CHAR(3) not null,
    product_name VARCHAR(20) not null,
    product_description VARCHAR(100) not null,
    product_unit_price int not null,
    product_quantity int not null,
    product_reorder_value int not null,
    product_category_code CHAR(3) not null,
    product_order_number int not null,
    CONSTRAINT 
        pk_products_product_code PRIMARY KEY(product_code)
)
ALTER TABLE products
    add CONSTRAINT fk_products_product_category_code FOREIGN KEY (product_category_code)
        REFERENCES categories(category_code)
ALTER TABLE products
    add CONSTRAINT fk_products_product_order_number FOREIGN KEY (product_order_number)
        REFERENCES orders(order_number)

insert into products (
                      product_code, 
                      product_name, 
                      product_description, 
                      product_unit_price, 
                      product_quantity,
                      product_reorder_value, 
                      product_category_code, 
                      product_order_number)

 VALUES 
        ('APP', 'Apples', 'Apple is a type of fruit', 30, 10, 5, 'FR1', 200 ),
        ('OGG','Oranges', 'Orange is a type of fruit', 50, 5, 5, 'FR1', 201),
        ('MGG', 'Mangoes', 'Mango is a type of fruit', 65, 20, 4,'FR1',223 ),
        ('GVV','Guava','Guava is a type of fruit', 40, 12, 7, 'FR1', 210),
        ('CRY','Cherry','Cherry is a type of fruit', 20, 15, 5, 'FR1', 211),

        ('TMT','Tomatoes', 'Tomato is a type of vegetable', 2, 25, 5, 'VG1', 202 ),
        ('PGG', 'Potatoes', 'Poatato is a type of vegetable', 10,15,  7, 'VG1', 203 ),
        ('CAR', 'Carrot', 'Carrot is a type of vegetable', 3,17,  8, 'VG1', 224 ),
        ('BPP', 'Bell Pepper', 'Bell Pepper is a type of vegetable', 5, 12, 3, 'VG1', 212 ),  
        ('PEP', 'Peas', 'Peas is a type of vegetable', 8, 10 , 5, 'VG1', 213 ),

        ('WGG','Wheat', 'Wheat is a type of Grain', 9,3 , 1, 'GR1', 204),
        ('RII','Rice', 'Rice is a type of Grain', 10, 9, 8, 'GR1', 205),
        ('OAT','Oats', 'Oats is a type of Grain', 5, 5, 2, 'GR1',214 ),
        ('BRY','Barley', 'Barley is a type of Grain', 6, 12, 2, 'GR1',215 ),
        ('CRL','Cereals', 'Cereals is a type of Grain', 3, 8, 2, 'GR1',216),

        ('MTT','Meat', 'Meat is a type of Protein', 6, 11,  9,'PR1',206 ),        
        ('EGG','Eggs', 'Eggs is a type of Protein', 8, 6, 3,'PR1',207),       
        ('NUT','Nuts', 'Nuts is a type of Protein', 5, 5, 2,'PR1',217 ),        
        ('TOF','Tofu', 'Tofu is a type of Protein', 8, 8, 3,'PR1',219 ),        
        ('BNS','Beans', 'Beans is a type of Protein', 7, 12, 3,'PR1',218 ),

        ('BTT','Butter', 'Butter is a type of Dairy Products', 9, 10,2,'DR1',208 ),
        ('CSS','Cheese', 'Cheese is a type of Dairy Products', 8, 15,5,'DR1',209 ),
        ('MIL','Milk', 'Milk is a type of Dairy Products', 9, 3,2,'DR1',221),
        ('YGG','Yogurt', 'Yogurt is a type of Dairy Products', 6, 12,2,'DR1',220 ),
        ('ICE','Ice Cream', 'Ice Cream is a type of Dairy Products', 7, 15,2,'DR1',222 )
GO
CREATE table suppliers(
    supplier_id int IDENTITY not null,
    supplier_name VARCHAR(20) not null,
    supplier_email VARCHAR(25) not null,
    supplier_city VARCHAR(20) not null,
    supplier_postal_code int not null,
    supplier_country VARCHAR(25) not NULL,
    supplier_order_number INT not null,
    CONSTRAINT
        pk_suppliers_supplier_id PRIMARY KEY(supplier_id),
    CONSTRAINT
        u_suppliers_supplier_email UNIQUE(supplier_email)
)
ALTER TABLE suppliers
    ADD CONSTRAINT fk_suppliers_supplier_order_number FOREIGN KEY(supplier_order_number)
        REFERENCES orders(order_number)
insert into suppliers (
                       supplier_name, 
                       supplier_email, 
                       supplier_city, 
                       supplier_postal_code, 
                       supplier_country,
                       supplier_order_number)

values 
       ('Walmart', 'walmart@gmail.com', 'Syracuse', 13210, 'USA',224),
       ('Target', 'target@gmail.com', 'Liverpool', 13250, 'USA',223 ),
       ('Wegmans', 'wegmans@gmail.com', 'Ithaca', 13265, 'USA' ,222),
       ('Wegmans', 'wegmans1@gmail.com', 'Ithaca', 13265, 'USA' ,200),
       ('Wegmans', 'wegmans2@gmail.com', 'Ithaca', 13265, 'USA' ,201),
       ('Target', 'target1@gmail.com', 'Liverpool', 13265, 'USA' ,205),
       ('Walmart', 'walmart1@gmail.com', 'Albany', 13210, 'USA',224),
       ('Walmart', 'walmart2@gmail.com', 'Rochester', 13210, 'USA',224),
       ('Walmart', 'walmart3@gmail.com', 'Bringhamton', 13210, 'USA',224)
       
GO 
CREATE TABLE payments (
    payment_number int IDENTITY (101,1) not null,
    payment_date DATE not null,
    payment_total_amount int not null,
    payment_order_number int not null,
    payment_mode VARCHAR(50) not null
    CONSTRAINT 
        pk_payments_payment_number PRIMARY KEY(payment_number),
)
ALTER TABLE payments
    ADD CONSTRAINT fk_payments_payment_order_number FOREIGN KEY (payment_order_number)
        REFERENCES orders(order_number)

insert into payments ( 
                    payment_date, 
                    payment_total_amount, 
                    payment_order_number,
                    payment_mode)

values 
        ('2021-12-05',306, 200,'Debit Card'),
        ('2021-11-13',252, 201,'Apple Pay'),                                                                                     
        ('2021-11-25',17, 202,'Credit Card'),
        ('2021-06-03',21, 203,'Google wallet'),
        ('2020-05-04',18, 204,'Cash on Delivery'),
        ('2021-05-13',35, 205,'Cash on Delivery'),
        ('2020-05-04',67, 206,'Google Wallet'),
        ('2020-05-04',49, 207,'Apple Pay'),
        ('2020-03-01',94, 208,'Cash on Delivery'),
        ('2020-03-01',82, 209,'Debit Card'),
        ('2021-12-12',482, 210,'Credit Card'),
        ('2021-11-02',267, 211,'Apple Pay'),
        ('2021-10-02',48, 212,'Cash on Delivery'),
        ('2021-03-02',74, 213,'Credit Card'),
        ('2021-02-01',101, 214,'Debit Card'),
        ('2021-01-01',50, 215,'Apple Pay'),
        ('2022-05-08',17, 216,'Credit Card'),
        ('2021-09-08',35, 217,'Debit Card'),
        ('2020-11-12',63, 218,'Credit Card'),
        ('2020-10-11',82, 219,'Google Wallet'),
        ('2020-12-12',109, 220,'Credit Card'),
        ('2020-01-05',50, 221,'Cash On Delivery'),
        ('2021-08-09',16, 222,'Credit Card'),
        ('2021-05-11',265, 223,'Apple Pay'),
        ('2021-05-12',33, 224,'Debit Card'),
        ('2021-05-12',333, 200,'Google Wallet'),
        ('2021-06-12',600, 226,'Credit Card'),
        ('2021-09-09',9, 227,'Debit Card')

 
--STORED PROCEDURE
drop PROCEDURE if EXISTS order_upsert

GO
create PROCEDURE order_upsert(
    @oid int,
    @oname VARCHAR(20),
    @oquan int,
    @osubtotal int,
    @otax int,
    @oprice int,
    @odate DATE,
    @odetails VARCHAR(100)
) AS
    BEGIN
        if not exists 
            (select * from orders where order_number = @oid)
        BEGIN 
            INSERT into orders(
                                order_name,
                                order_quantity,
                                order_subtotal,
                                order_tax,
                                order_totalprice,
                                order_date,
                                order_details)
            VALUES(
                    @oname,
                    @oquan,
                    @osubtotal,
                    @otax,
                    @oprice,
                    @odate,
                    @odetails)
        END
    ELSE 
        BEGIN
            UPDATE orders
            set order_quantity =@oquan where order_number = @oid
            END
END

GO
create PROCEDURE c_upsert_products(
    @pcode CHAR(3),
    @pname VARCHAR(20),
    @pdescription VARCHAR(100),
    @punitprice int,
    @pquantity int,
    @preordervalue int,
    @pcatcode CHAR(3),
    @pordnum int 
) AS
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION
                IF   NOT EXISTS 
                    (select * from products where product_code = @pcode)
                BEGIN 
                    INSERT into products(product_code,
                                        product_name,
                                        product_description,
                                        product_unit_price,
                                        product_quantity,
                                        product_reorder_value,
                                        product_category_code,
                                        product_order_number)
                    VALUES(@pcode,
                        @pname,
                        @pdescription,
                        @punitprice,
                        @pquantity,
                        @preordervalue,
                        @pcatcode,
                        @pordnum)
                    if @@ROWCOUNT <> 1 THROW 50001, 'p_upsert_products: Insert Error', 1
                END
            ELSE 
                BEGIN
                    UPDATE products
                    set product_name =@pname, product_order_number = @pordnum
                        where product_code = @pcode
                    if @@ROWCOUNT <> 1 THROW 50001, 'p_upsert_products: Update Error', 1
                    END
                    COMMIT
        END TRY
          BEGIN CATCH 
            ROLLBACK
            ;
            THROW
        END CATCH
END

--Using the stored procedure
GO
EXEC order_upsert @oid = 26, @oname = 'Pulses',
                        @oquan = 20,
                        @osubtotal = 400,
                        @otax =5,
                        @oprice = 405,
                        @odate = '2022-06-10',
                        @odetails ='Ordered 20 pulse packets'

GO
EXEC c_upsert_products @pcode = 'PUL', @pname = 'Pulses',
                        @pdescription = 'Source of Protien',
                        @punitprice = 5,
                        @pquantity = 50,
                        @preordervalue = 10,
                        @pcatcode = 'PR1',
                        @pordnum = 225

--verify
select * from users
select * from managers
select * from volunteers
select * from suggestions
select * from staffs
select * from chapels
select * from categories
select * from orders
select * from products 
select * from suppliers
select * from payments