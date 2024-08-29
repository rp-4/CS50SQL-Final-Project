-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- example data

-- for group by error

/*
SELECT @@session.sql_mode;

copy everything other than 'ONLY_FULL_GROUP_BY'

SET sql_mode = 'copied_text_here'; */



/*  INSERT INTO users (username, password, first_name, last_name, email)
    VALUES ('rinkesh', 'testPassword', 'rinkesh', 'patel', 'temp@email.com'); */


/*
UPDATE users
SET last_login = NOW()
WHERE username = 'rinkesh'; */


-- ---------------------------------------------------------------------------------------------------

-- /*
-- insert dummy data in users table

INSERT INTO users (username, password, first_name, last_name, email, acc_created, last_login)
VALUES
    ('username1', '%6rO_f7%bY', 'First1', 'Last2', 'first_last_1@email.com', '2023-01-01 08:41:03', '2024-01-09 20:02:33'),
    ('username2', 'Tvt2wEWoW', 'First2', 'Last3', 'first_last_2@email.com', '2020-08-19 11:47:06', '2024-03-05 16:59:25'),
    ('username3', '0@7a6*mfyH', 'First3', 'Last4', 'first_last_3@email.com', '2024-05-17 15:14:00', '2024-07-21 21:08:21'),
    ('username4', 'V!24SVrEhn', 'First4', 'Last5', 'first_last_4@email.com', '2020-11-09 18:25:59', '2024-08-02 02:14:19'),
    ('username5', '@$5lQt^hSI', 'First5', 'Last6', 'first_last_5@email.com', '2021-10-19 08:56:45', '2024-01-23 03:21:09'),
    ('username6', 'f^3FtMh_h*', 'First6', 'Last7', 'first_last_6@email.com', '2023-12-18 02:18:28', '2024-04-17 18:22:50');


-- insert dummy data into categories table

INSERT INTO categories (category)
VALUES
    ('category'), ('Electronics'), ('Furniture'),
    ('Art'), ('Jewelry'), ('Cars'), ('Books'),
    ('Collectibles'), ('Sports'), ('Real Estate'), ('Fashion');


-- inser dummy data into listings as active

INSERT INTO listings (category_id, title, description, listing_price, datetime_added, added_by_user_id)
VALUES
    ((SELECT id FROM categories WHERE category = 'Books'), 'Item 1', 'Description for Item 1', '43.87', '2024-08-12 10:35:00', (SELECT id FROM users WHERE username = 'username4')),
    ((SELECT id FROM categories WHERE category = 'Jewelry'), 'Item 2','Description for Item 2','6.65','2024-07-28 15:21:00', (SELECT id FROM users WHERE username = 'username3')),
    ((SELECT id FROM categories WHERE category = 'Art'), 'Item 3','Description for Item 3','13.43','2024-08-15 09:42:00', (SELECT id FROM users WHERE username = 'username2')),
    ((SELECT id FROM categories WHERE category = 'Furniture'), 'Item 4','Description for Item 4','27.85','2024-07-30 12:00:00', (SELECT id FROM users WHERE username = 'username6')),
    ((SELECT id FROM categories WHERE category = 'Electronics'), 'Item 5','Description for Item 5','16.09','2024-08-11 21:14:40', (SELECT id FROM users WHERE username = 'username4')),
    ((SELECT id FROM categories WHERE category = 'Books'), 'Item 6','Description for Item 6','21.28','2024-10-25 1:48:40', (SELECT id FROM users WHERE username = 'username1'));


-- inserting dummy data into comments table

INSERT INTO comments (user_id, listing_id, comment, timestamp)
VALUE
    ((SELECT id FROM users WHERE username = 'username2'), (SELECT id FROM listings WHERE title = 'Item 1'), 'comment_1_on_item_1', '2024-11-17 12:51:02'),
    ((SELECT id FROM users WHERE username = 'username4'), (SELECT id FROM listings WHERE title = 'Item 3'), 'comment_1_on_item_3', '2024-10-26 22:26:49'),
    ((SELECT id FROM users WHERE username = 'username5'), (SELECT id FROM listings WHERE title = 'Item 1'), 'comment_2_on_item_1', '2024-11-27 02:17:54'),
    ((SELECT id FROM users WHERE username = 'username2'), (SELECT id FROM listings WHERE title = 'Item 4'), 'comment_1_on_item_4', '2024-12-13 10:33:06'),
    ((SELECT id FROM users WHERE username = 'username1'), (SELECT id FROM listings WHERE title = 'Item 2'), 'comment_1_on_item_2', '2024-12-05 00:50:50');


-- insert dummy data into bids

INSERT INTO bids (user_id, listing_id, action, price)
VALUE (1, 2, 'bid_placed', 6.70),
    (4, 2, 'bid_placed', 7.68),
    (6, 2, 'bid_placed', 8.00),
    (4, 2, 'bid_placed', 10.00);

INSERT INTO bids (user_id, listing_id, action, price)
VALUE (1, 3, 'bid_placed', 43),
    (4, 3, 'bid_placed', 45),
    (6, 3, 'bid_placed', 50),
    (5, 3, 'bid_placed', 55);


-- insert dummy data into watchlists

INSERT INTO watchlists (user_id, listing_id)
VALUE (1, 2), (1, 4), (3, 1), (2, 4), (2, 5);

-- */

-- -------------------------------------------------------------------------------------------------------------
-- /*
-- example queries

-- query to get all listings info

SELECT users.username, listings.title, categories.category, listings.listing_price,  listings.status FROM listings
JOIN categories ON
listings.category_id = categories.id
JOIN users ON
users.id = listings.added_by_user_id;


-- updating listing status as closed

UPDATE listings
SET status = 'closed'
WHERE title = 'Item 2';

UPDATE listings
SET status = 'closed'
WHERE title = 'Item 3';


-- query to get all listings info

SELECT users.username, listings.title, categories.category, listings.listing_price,  listings.status FROM listings
JOIN categories ON
listings.category_id = categories.id
JOIN users ON
users.id = listings.added_by_user_id;


-- query to get all closed listing with winners username and winning price

SELECT listings.id, listings.title, listings.status, max_bids.max_price, users.username AS winner FROM listings
JOIN winners ON
winners.listing_id = listings.id
JOIN bids ON
bids.listing_id = winners.listing_id
JOIN users ON
users.id = bids.user_id
JOIN (
    SELECT listing_id, MAX(price) AS max_price
    FROM bids
    GROUP BY listing_id
) AS max_bids
ON bids.listing_id = max_bids.listing_id AND bids.price = max_bids.max_price;


-- query to get all listings stores in watchlists

SELECT users.username, listings.title AS watchlist FROM watchlists
JOIN users ON
users.id = watchlists.user_id
JOIN listings ON
listings.id = watchlists.listing_id
WHERE watchlists.user_id = 2;


-- query to get all listings under the category

SELECT listings.title, categories.category FROM listings
JOIN categories ON
categories.id = listings.category_id
WHERE category = 'Books';


-- query to get all comments on specific listing

SELECT listings.title, comments.comment, users.username FROM comments
JOIN listings ON
listings.id = comments.listing_id
JOIN users ON
users.id = comments.user_id
WHERE listings.id = 1;


-- query to delete any category

DELETE FROM categories WHERE category = 'Real Estate';

SELECT * FROM categories;


-- */
