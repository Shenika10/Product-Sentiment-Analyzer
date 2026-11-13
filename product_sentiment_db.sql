-- Product Sentiment Analyzer and Review Dashboard
DROP TABLE IF EXISTS sentiment_results CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS search_history CASCADE;
DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
    product_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    price NUMERIC(10,2) CHECK (price >= 0)
);

CREATE TABLE reviews (
    review_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id INTEGER NOT NULL,
    review_text TEXT NOT NULL,
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    review_date DATE DEFAULT CURRENT_DATE,
    CONSTRAINT fk_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE CASCADE
);

CREATE TABLE sentiment_results (
    sentiment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    review_id INTEGER NOT NULL,
    sentiment VARCHAR(20) NOT NULL CHECK (sentiment IN ('Positive','Negative','Neutral')),
    confidence_score NUMERIC(4,2) CHECK (confidence_score BETWEEN 0 AND 1),
    CONSTRAINT fk_review
        FOREIGN KEY (review_id)
        REFERENCES reviews(review_id)
        ON DELETE CASCADE
);

CREATE TABLE search_history (
    search_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    keyword VARCHAR(255) NOT NULL,
    search_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products(product_name,category,brand,price) VALUES
('iPhone 15','Mobile','Apple',79999),
('Galaxy S24','Mobile','Samsung',74999),
('Boat Airdopes 141','Earbuds','Boat',1299);

INSERT INTO reviews(product_id,review_text,rating,review_date) VALUES
(1,'Excellent camera and battery life.',5,'2026-07-01'),
(2,'Very good performance but expensive.',4,'2026-07-01'),
(3,'Sound quality is average.',3,'2026-07-01');

INSERT INTO sentiment_results(review_id,sentiment,confidence_score) VALUES
(1,'Positive',0.98),
(2,'Positive',0.91),
(3,'Neutral',0.75);

INSERT INTO search_history(keyword) VALUES
('iPhone 15'),
('Galaxy S24'),
('Boat Airdopes');

-- Sample JOIN
SELECT p.product_name,r.review_text,s.sentiment,s.confidence_score
FROM products p
JOIN reviews r ON p.product_id=r.product_id
JOIN sentiment_results s ON r.review_id=s.review_id;
