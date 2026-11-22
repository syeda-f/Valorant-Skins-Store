DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS skin;
DROP TABLE IF EXISTS cart_item;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_item;
DROP TABLE IF EXISTS shipment;
DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS coupon;

CREATE TABLE customer (
   custId INTEGER AUTO_INCREMENT PRIMARY KEY,
   custName VARCHAR(200) NOT NULL,
   password CHAR(60) NOT NULL,
   email VARCHAR(100) NOT NULL,
   phone VARCHAR(12) NOT NULL,
   acceptsNotifications BOOLEAN NOT NULL DEFAULT 0,
   createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE address (
   addressId INTEGER AUTO_INCREMENT PRIMARY KEY,
   custId INTEGER NOT NULL,
   houseNumber INTEGER,
   street VARCHAR(100) NOT NULL,
   landmark VARCHAR(100) NOT NULL,
   cityName VARCHAR(50) NOT NULL,
   regionName VARCHAR(50) NOT NULL,  
   countryCode CHAR(2) NOT NULL,
   postalCode VARCHAR(8) NOT NULL,    
   FOREIGN KEY (custId) REFERENCES customer(custId) ON DELETE CASCADE
);

CREATE TABLE skin (
   skinId INTEGER AUTO_INCREMENT PRIMARY KEY,
   skinName VARCHAR(100) NOT NULL,
   category  ENUM('Melee', 'Sidearms', 'Primary') NOT NULL,
   weaponName ENUM('Melee', 'Classic', 'Shorty', 'Frenzy', 'Ghost', 'Sheriff', 'Stinger', 'Spectre', 'Bulldog', 'Bucky', 'Judge', 'Vandal', 'Phantom', 'Guardian', 'Operator', 'Marshal', 'Warden', 'Ares', 'Odin') NOT NULL,
   radianites INTEGER NOT NULL,
   description TEXT NOT NULL,
   rating INTEGER NOT NULL DEFAULT 0,
   stock INTEGER NOT NULL DEFAULT 0,
   imageOne VARCHAR(300) NOT NULL,
   imageTwo VARCHAR(300) NOT NULL,
   imageThree VARCHAR(300) NOT NULL
);

CREATE TABLE cart_item (
   cartItemId INTEGER AUTO_INCREMENT PRIMARY KEY,
   custId INTEGER NOT NULL,
   skinId INTEGER NOT NULL,
   quantity INTEGER NOT NULL DEFAULT 1,
   UNIQUE (custId, skinId),
   FOREIGN KEY (custId) REFERENCES customer(custId) ON DELETE CASCADE,
   FOREIGN KEY (skinId) REFERENCES skin(skinId) ON DELETE CASCADE
);
 
CREATE TABLE orders (
   orderId INTEGER AUTO_INCREMENT PRIMARY KEY,
   custId INTEGER NOT NULL,
   total INTEGER NOT NULL,
   paymentType ENUM('cash', 'card', 'kidney', 'kalakhand', 'biryani'),
   deliveryType ENUM('delivery', 'pickup', 'helicopter') NOT NULL DEFAULT 'delivery',
   placedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
   FOREIGN KEY (custId) REFERENCES customer(custId)
);

CREATE TABLE order_item (
   orderItemId INTEGER AUTO_INCREMENT PRIMARY KEY,
   orderId INTEGER NOT NULL,
   skinId INTEGER NOT NULL,
   unitPrice INTEGER NOT NULL,
   quantity INTEGER NOT NULL,
   FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE,
   FOREIGN KEY (skinId) REFERENCES skin(skinId) ON DELETE CASCADE
);

CREATE TABLE shipment (
   shipmentId INTEGER AUTO_INCREMENT PRIMARY KEY,
   orderId INTEGER NOT NULL,
   shippedAt DATETIME NULL,
   deliveredAt DATETIME NULL,
   trackingNumber VARCHAR(100) NOT NULL,
   FOREIGN KEY (orderId) REFERENCES orders (orderId) ON DELETE CASCADE
);

CREATE TABLE review (
   reviewId INTEGER AUTO_INCREMENT PRIMARY KEY,
   stars ENUM('0', '1', '2', '3', '4', '5') NOT NULL,
   comment TEXT NOT NULL,
   custId INTEGER NOT NULL,
   skinId INTEGER NOT NULL,
   createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
   FOREIGN KEY (custId) REFERENCES customer(custId),
   FOREIGN KEY (skinId) REFERENCES skin(skinId) ON DELETE CASCADE
);

CREATE TABLE coupon (
   coupId INTEGER AUTO_INCREMENT PRIMARY KEY,
   orderId INTEGER NOT NULL,
   code VARCHAR(30) NOT NULL UNIQUE,
   discountType INTEGER NOT NULL,
   expiresAt DATETIME NOT NULL,
   FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE
);

-- creating four initial users
INSERT INTO customer(custName, password, email, phone) VALUES
    ('Zizi', 'iLoveEcomm123$', 'zizi@gmail.com', '962345678321'),
    ('Bread', 'frenchfriesontop123@', 'panadera67@gmail.com', '967676767676'),
    ('Windi', 'bottomFragger67&', 'windthelvp@gmail.com', '912345678908'),
    ('Kakdi', 'bangaloreForever67#', 'jacob@gmail.com', '965826450263'),
    ('Bhindi', 'mEoWmEoW67*', 'pawesomecat@gmail.com', '954185273543');

-- creating addresses for the initial users
INSERT INTO address(custId, houseNumber, street, landmark, cityName, regionName, countryCode, postalCode) VALUES
    (1, 76, 'Kabsa Street', 'Naval Base', 'Al-Jubail', 'Eastern Province', 'SA', '57676767'),
    (2, 89, '7 Tombs Road', 'Golconda Fort', 'Gachibowli', 'Hyderabad', 'IN', '55672174'),
    (3, 36, 'Azad Kashmir Street', 'Rawal Lake', 'Rawalpindi', 'Punjab', 'PK', '56789962'),
    (4, 12, 'Biryani Street', 'BTM Water Tank', 'Bengaluru', 'Karnataka', 'IN', '578739'),
    (5, 42, 'Heavens Highway', 'Twin Towers', 'Istanbul', 'Turkiye', 'TR', '629537');

--- creating skins
INSERT INTO skin(skinName, category, weaponName, radianites, description, rating, stock, imageOne, imageTwo, imageThree) VALUES
    ('Bubblegum Deathwish Chainsaw', 'Melee', 'Melee', 4350, 'A loud pink and blue chainsaw that looks like candy but sounds like trouble.', 0, 50, '/images/bubblegum.png', 'fdsf', 'fdsf'),
    ('Oni Claw', 'Melee', 'Melee', 3200, 'Dark red and black claws inspired by the fierce Japanese Oni demon.', 0, 40, '/images/oniclaw.png', 'fdsf', 'fdsf'),
    ('Sakura Classic', 'Sidearms', 'Classic', 1275, 'Soft pink cherry blossoms spread across a clean, light design.', 0, 100, '/images/sakura.png', 'fdsf', 'fdsf'),
    ('Jellybeam Shorty', 'Sidearms', 'Shorty', 850, 'Bright, chewy jellybean colours with a fun, playful shine.', 0, 80, '/images/jellybean.png', 'fdsf', 'fdsf'),
    ('Convergence Frenzy', 'Sidearms', 'Frenzy', 1500, 'A sleek, techy look with glowing lines that meet in the middle.', 0, 70, '/images/frenzy.png', 'fdsf', 'fdsf'),
    ('Gaia''s Vengeance Ghost', 'Sidearms', 'Ghost', 2000, 'Green vines and stone-like details make it look like nature is fighting back.', 0, 60, '/images/ghost.png', 'fdsf', 'fdsf'),
    ('Kuronami Sheriff', 'Sidearms', 'Sheriff', 1750, 'A dark, stormy design inspired by a rolling black wave.', 0, 90, '/images/sheriff.png', 'fdsf', 'fdsf'),
    ('Tactiplay Stinger', 'Primary', 'Stinger', 2200, 'Looks like a toy built from bright game-style blocks and buttons.', 0, 50, '/images/stinger.png', 'fdsf', 'fdsf'),
    ('Evori Dreamwings Spectre', 'Primary', 'Spectre', 2500, 'Soft glowing wings and dreamy colours that look like they came from a fairy tale.', 0, 40, '/images/spectre.png', 'fdsf', 'fdsf'),
    ('Neptune Bulldog', 'Primary', 'Bulldog', 1800, 'Deep ocean blues and sea-green shine, like something pulled from the bottom of the sea.', 0, 70, '/images/bulldog.png', 'fdsf', 'fdsf'),
    ('Stormborne Bucky', 'Primary', 'Bucky', 1600, 'Grey storm clouds with sparks of lightning running through them.', 0, 60, '/images/bucky.png', 'fdsf', 'fdsf'),
    ('POLYfox Judge', 'Primary', 'Judge', 1400, 'Sharp, folded shapes in warm orange, like a paper fox that came to life.', 0, 80, '/images/judge.png', 'fdsf', 'fdsf'),
    ('Avalanche Vandal', 'Primary', 'Vandal', 3000, 'Icy white and blue with a cold, snowy finish.', 0, 50, '/images/vandal.png', 'fdsf', 'fdsf'),
    ('Doodle Buds Phantom', 'Primary', 'Phantom', 2700, 'Looks hand-drawn, with cute scribbles and little doodle faces all over.', 0, 40, '/images/phantom.png', 'fdsf', 'fdsf'),
    ('Ego Guardian', 'Primary', 'Guardian', 1900, 'Clean, bold lines and a proud, confident style.', 0, 70, '/images/guardian.png', 'fdsf', 'fdsf'),
    ('Spline Operator', 'Primary', 'Operator', 3500, 'Smooth, flowing curves in cool colours, like a drawing made with one long line.', 0, 60, '/images/operator.png', 'fdsf', 'fdsf'),
    ('Luna Marshal', 'Primary', 'Marshal', 2100, 'Silver and deep blue with a soft moon glow.', 0, 80, '/images/marshal.png', 'fdsf', 'fdsf'),
    ('Galleria Warden', 'Primary', 'Warden', 2300, 'Looks like a piece of modern art with bold shapes and colours.', 0, 90, '/images/warden.png', 'fdsf', 'fdsf'),
    ('Mystbloom Ares', 'Primary', 'Ares', 2400, 'Flowers wrapped in drifting purple mist, pretty and mysterious.', 0, 50, '/images/ares.png', 'fdsf', 'fdsf'),
    ('Dolmir''s Revenge Odin', 'Primary', 'Odin', 2800, 'Dark, angry and full of fire, like a creature breaking free.', 0, 100, '/images/odin.png', 'fdsf', 'fdsf');
   
--- creating reviews for initialized skins
INSERT INTO review (stars, comment, custId, skinId) VALUES
(3, 'It looks pretty fire but the animation could be smoother :/', 4, 1),
(5, 'ABSOLUTELY BEAUTIFUL ❤️❤️❤️', 1, 1),
(4, 'Sooo cooooot!!! Matches Yoru mains!', 3, 2),
(5, 'GARR!!! ferocious & daunting :)))', 2, 2),
(2, 'Nice but not quite worth so many radianites :(((', 5, 3),
(4, 'BOOTIFUL 🤩 in love with this!!!', 4, 3),
(5, 'no comments just ⭐⭐⭐⭐⭐', 1, 4),
(2, 'Very plain and boring. Do better @RiotGames', 2, 5),
(5, 'Kawaiiiii😍 100% RECOMMENDED GUYS', 2, 5),
(4, 'Looks absolutely ethereal! Cant wait to get in headshots with this beauty XX', 5, 6),
(3, 'could use a little more flash?', 3, 7),
(2, 'bleh. make smarter purchases than this skin everyone 👎👎👎', 2, 7),
(1, 'This is soo ugly XDXD looks like a zombie 💀', 5, 8),
(5, 'very cute. clean animation. reasonable price. 67', 1, 8),
(3, 'AbSoLutElY gOrGeOuS ✨ Too expensive though, I''d need to sell a kidney to afford it 😭', 4, 9),
(2, 'An absolute waste of my money smh 🙄 Dont get this trash gang 🥀', 2, 10),
(5, 'very very bougie. me likey. ❤️', 5, 10),
(4, 'I''d die to land headshots with this skinnnnn', 3, 11),
(2, 'I can make a better design with my eyes closed & my hands tied 🤦🏼‍♀️', 1, 11),
(1, 'Ew. Dont tell me the designers get paid to make junk like this....', 2, 12),
(4, 'My all-time favourite is the ice variant!!! I would sell my soul to eat it.', 4, 12);
