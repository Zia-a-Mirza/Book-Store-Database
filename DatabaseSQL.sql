--
-- File generated with SQLiteStudio v3.4.3 on Wed Apr 19 23:58:45 2023
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: AUTHOR
CREATE TABLE IF NOT EXISTS AUTHOR (
    AuthorFname TEXT    NOT NULL,
    AuthorMname TEXT,
    AuthorLname TEXT    NOT NULL,
    AuthorID    INTEGER PRIMARY KEY AUTOINCREMENT
                        UNIQUE
                        NOT NULL
);


-- Table: BOOK
CREATE TABLE IF NOT EXISTS BOOK (
    ISBN      NUMERIC (13)   PRIMARY KEY
                             NOT NULL
                             UNIQUE,
    Title     TEXT (70)      NOT NULL,
    Publisher TEXT (70)      NOT NULL
                             REFERENCES PUBLISHER (Name),
    Year      NUMERIC (4)    NOT NULL,
    Price     NUMERIC (6, 2) NOT NULL
);


-- Table: BOOK_AUTHOR
CREATE TABLE IF NOT EXISTS BOOK_AUTHOR (
    ISBN   NUMERIC (13) REFERENCES BOOK (ISBN) ON UPDATE CASCADE
                        NOT NULL,
    Author INTEGER      REFERENCES AUTHOR (AuthorID) ON UPDATE CASCADE
                        NOT NULL,
    PRIMARY KEY (
        ISBN,
        Author
    )
);


-- Table: BOOK_CATEGORY
CREATE TABLE IF NOT EXISTS BOOK_CATEGORY (
    ISBN     TEXT REFERENCES BOOK (ISBN) 
                  NOT NULL,
    Category TEXT NOT NULL,
    PRIMARY KEY (
        ISBN ASC,
        Category ASC
    )
);


-- Table: BOOKMARK
CREATE TABLE IF NOT EXISTS BOOKMARK (
    ProductNo NUMERIC (13)   PRIMARY KEY
                             UNIQUE
                             NOT NULL,
    Color     TEXT (20)      NOT NULL,
    Size      TEXT (1)       NOT NULL
                             CHECK (size = 'S' OR 
                                    size = 'M' OR 
                                    size = 'L'),
    Price     NUMERIC (6, 2) NOT NULL
);


-- Table: CUSTOMER
CREATE TABLE IF NOT EXISTS CUSTOMER (
    FName      TEXT (20)    NOT NULL,
    LName      TEXT (20)    NOT NULL,
    Birthdate  TEXT (10),
    Email      TEXT (40)    UNIQUE
                            NOT NULL,
    Phone      NUMERIC (13) NOT NULL
                            UNIQUE,
    Address    TEXT         NOT NULL,
    CustomerID INTEGER      PRIMARY KEY AUTOINCREMENT
                            UNIQUE
                            NOT NULL
);


-- Table: ORDER_BOOKMARKS
CREATE TABLE IF NOT EXISTS ORDER_BOOKMARKS (
    OrderNo           INTEGER   REFERENCES ORDERS (OrderNo) 
                                NOT NULL,
    ProductNo         INTEGER   NOT NULL
                                REFERENCES BOOKMARK (ProductNo),
    QuantityPurchased INTEGER   NOT NULL,
    Status            TEXT (12) CHECK (Status = 'Complete' OR 
                                       Status = 'Incomplete' OR 
                                       Status = 'Failed') 
                                NOT NULL,
    PRIMARY KEY (
        OrderNo ASC,
        ProductNo ASC
    )
);


-- Table: ORDER_BOOKS
CREATE TABLE IF NOT EXISTS ORDER_BOOKS (
    OrderNo           INTEGER      REFERENCES ORDERS (OrderNo) 
                                   NOT NULL,
    ISBN              NUMERIC (13) NOT NULL
                                   REFERENCES BOOK (ISBN),
    QuantityPurchased INTEGER      NOT NULL,
    Status            TEXT (12)    CHECK (Status = 'Complete' OR 
                                          Status = 'Incomplete' OR 
                                          Status = 'Failed') 
                                   NOT NULL,
    PRIMARY KEY (
        OrderNo ASC,
        ISBN ASC
    )
);


-- Table: ORDERS
CREATE TABLE IF NOT EXISTS ORDERS (
    OrderNo        INTEGER      PRIMARY KEY AUTOINCREMENT
                                UNIQUE
                                NOT NULL,
    Status         TEXT (12)    NOT NULL
                                CHECK (Status = 'Complete' OR 
                                       Status = 'Incomplete' OR 
                                       Status = 'Failed'),
    CustID         INTEGER (20) NOT NULL
                                REFERENCES CUSTOMER (CustomerID),
    PaymentMethod  TEXT (20)    NOT NULL,
    CreationDate   TEXT (10)    NOT NULL,
    CompletionDate TEXT (10),
    Store          INTEGER      REFERENCES STORE (StoreID) 
                                NOT NULL
);


-- Table: PUBLISHER
CREATE TABLE IF NOT EXISTS PUBLISHER (
    Name TEXT (70) PRIMARY KEY
                 UNIQUE
                 NOT NULL
);


-- Table: STORE
CREATE TABLE IF NOT EXISTS STORE (
    Name    TEXT (70) UNIQUE
                      NOT NULL,
    Address TEXT      NOT NULL,
    StoreID INTEGER   PRIMARY KEY AUTOINCREMENT
                      NOT NULL
                      UNIQUE
);


-- Table: STORE_BOOKMARKS
CREATE TABLE IF NOT EXISTS STORE_BOOKMARKS (
    StoreID         INTEGER REFERENCES STORE (StoreID) 
                            NOT NULL,
    ProductNo       INTEGER REFERENCES BOOKMARK (ProductNo) 
                            NOT NULL,
    QuantityInStock INTEGER NOT NULL,
    PRIMARY KEY (
        StoreID ASC,
        ProductNo ASC
    )
);


-- Table: STORE_BOOKS
CREATE TABLE IF NOT EXISTS STORE_BOOKS (
    StoreID         INTEGER      REFERENCES STORE (StoreID) 
                                 NOT NULL,
    ISBN            NUMERIC (13) NOT NULL
                                 REFERENCES BOOK (ISBN),
    QuantityInStock INTEGER      NOT NULL,
    PRIMARY KEY (
        StoreID ASC,
        ISBN ASC
    )
);


-- Table: SUPPLIER
CREATE TABLE IF NOT EXISTS SUPPLIER (
    Name    TEXT (70) PRIMARY KEY
                      UNIQUE
                      NOT NULL,
    Address TEXT      NOT NULL
);


-- Table: SUPPLY_ORDER
CREATE TABLE IF NOT EXISTS SUPPLY_ORDER (
    Supplier  TEXT (70) REFERENCES SUPPLIER (Name) 
                        NOT NULL,
    Warehouse INTEGER   REFERENCES WAREHOUSE (ID) 
                        NOT NULL,
    OrderID   INTEGER   PRIMARY KEY AUTOINCREMENT
                        NOT NULL,
    Date      TEXT (10) NOT NULL
);


-- Table: SUPPLY_ORDER_BOOKMARKS
CREATE TABLE IF NOT EXISTS SUPPLY_ORDER_BOOKMARKS (
    OrderNo           INTEGER REFERENCES SUPPLY_ORDER (OrderID) 
                              NOT NULL,
    ProductNo         INTEGER NOT NULL
                              REFERENCES BOOKMARK (ProductNo),
    QuantityPurchased INTEGER NOT NULL,
    PRIMARY KEY (
        OrderNo ASC,
        ProductNo ASC
    )
);


-- Table: SUPPLY_ORDER_BOOKS
CREATE TABLE IF NOT EXISTS SUPPLY_ORDER_BOOKS (
    OrderNo           INTEGER      REFERENCES SUPPLY_ORDER (OrderID) 
                                   NOT NULL,
    ISBN              NUMERIC (13) NOT NULL
                                   REFERENCES BOOK (ISBN),
    QuantityPurchased INTEGER      NOT NULL,
    PRIMARY KEY (
        OrderNo ASC,
        ISBN ASC
    )
);


-- Table: WAREHOUSE
CREATE TABLE IF NOT EXISTS WAREHOUSE (
    Address TEXT     NOT NULL,
    Size    TEXT (1) NOT NULL
                     CHECK (size = 'S' OR 
                            size = 'M' OR 
                            size = 'L'),
    ID      INTEGER  PRIMARY KEY AUTOINCREMENT
                     NOT NULL
                     UNIQUE
);


-- Table: WAREHOUSE_BOOKMARKS
CREATE TABLE IF NOT EXISTS WAREHOUSE_BOOKMARKS (
    WarehouseID     INTEGER NOT NULL
                            REFERENCES WAREHOUSE (ID),
    ProductNo       INTEGER REFERENCES BOOKMARK (ProductNo) 
                            NOT NULL,
    QuantityInStock INTEGER NOT NULL,
    PRIMARY KEY (
        WarehouseID ASC,
        ProductNo ASC
    )
);


-- Table: WAREHOUSE_BOOKS
CREATE TABLE IF NOT EXISTS WAREHOUSE_BOOKS (
    WarehouseID     INTEGER NOT NULL
                            REFERENCES WAREHOUSE (ID),
    ISBN            NUMERIC NOT NULL
                            REFERENCES BOOK (ISBN),
    QuantityInStock INTEGER NOT NULL,
    PRIMARY KEY (
        WarehouseID ASC,
        ISBN ASC
    )
);


-- Table: WAREHOUSE_ORDER
CREATE TABLE IF NOT EXISTS WAREHOUSE_ORDER (
    Store     INTEGER   REFERENCES STORE (StoreID) 
                        NOT NULL,
    Warehouse INTEGER   REFERENCES WAREHOUSE (ID) 
                        NOT NULL,
    OrderID   INTEGER   PRIMARY KEY AUTOINCREMENT
                        NOT NULL,
    Date      TEXT (10) NOT NULL
);


-- Table: WAREHOUSE_ORDER_BOOKMARKS
CREATE TABLE IF NOT EXISTS WAREHOUSE_ORDER_BOOKMARKS (
    OrderNo       INTEGER REFERENCES WAREHOUSE_ORDER (OrderID) 
                          NOT NULL,
    ProductNo     INTEGER NOT NULL
                          REFERENCES BOOKMARK (ProductNo),
    QuantityMoved INTEGER NOT NULL,
    PRIMARY KEY (
        OrderNo ASC,
        ProductNo ASC
    )
);


-- Table: WAREHOUSE_ORDER_BOOKS
CREATE TABLE IF NOT EXISTS WAREHOUSE_ORDER_BOOKS (
    OrderNo       INTEGER      REFERENCES WAREHOUSE_ORDER (OrderID) 
                               NOT NULL,
    ISBN          NUMERIC (13) NOT NULL
                               REFERENCES BOOK (ISBN),
    QuantityMoved INTEGER      NOT NULL,
    PRIMARY KEY (
        OrderNo ASC,
        ISBN ASC
    )
);


-- Index: customerNameIndex
CREATE INDEX IF NOT EXISTS customerNameIndex ON CUSTOMER (
    FName,
    LName
);


-- Index: customerNameOrdersIndex
CREATE INDEX IF NOT EXISTS customerNameOrdersIndex ON ORDERS (
    CustID
);


-- Trigger: Decrase Store Bookmark Stock on Insert
CREATE TRIGGER IF NOT EXISTS [Decrase Store Bookmark Stock on Insert]
                       AFTER INSERT
                          ON ORDER_BOOKMARKS
                        WHEN Status = 'Complete'
BEGIN
    UPDATE STORE_BOOKMARKS
       SET QuantityInStock = QuantityInStock - ORDER_BOOKMARKS.QuantityPurchased
     WHERE ProductNo = ORDER_BOOKMARKS.ProductNo;
END;


-- Trigger: Decrease Store Book Stock on Insert
CREATE TRIGGER IF NOT EXISTS [Decrease Store Book Stock on Insert]
                       AFTER INSERT
                          ON ORDER_BOOKS
                        WHEN Status = 'Complete'
BEGIN
    UPDATE STORE_BOOKS
       SET QuantityInStock = QuantityInStock - ORDER_BOOKS.QuantityPurchased
     WHERE ISBN = ORDER_BOOKS.ISBN;
END;


-- Trigger: Decrease Store Book Stock on Update
CREATE TRIGGER IF NOT EXISTS [Decrease Store Book Stock on Update]
                       AFTER UPDATE
                          ON ORDER_BOOKS
                        WHEN Status = 'Complete'
BEGIN
    UPDATE STORE_BOOKS
       SET QuantityInStock = QuantityInStock - ORDER_BOOKS.QuantityPurchased
     WHERE ISBN = ORDER_BOOKS.ISBN;
END;


-- Trigger: Decrease Store Bookmark Stock on Update
CREATE TRIGGER IF NOT EXISTS [Decrease Store Bookmark Stock on Update]
                       AFTER UPDATE
                          ON ORDER_BOOKMARKS
                        WHEN Status = 'Complete'
BEGIN
    UPDATE STORE_BOOKMARKS
       SET QuantityInStock = QuantityInStock - ORDER_BOOKMARKS.QuantityPurchased
     WHERE ProductNo = ORDER_BOOKMARKS.ProductNo;
END;


-- Trigger: Decrease Warehouse Book Stock
CREATE TRIGGER IF NOT EXISTS [Decrease Warehouse Book Stock]
                       AFTER INSERT
                          ON WAREHOUSE_ORDER_BOOKS
BEGIN
    UPDATE WAREHOUSE_BOOKS
       SET QuantityInStock = QuantityInStock - WAREHOUSE_ORDER_BOOKS.QuantityMoved
     WHERE ISBN = WAREHOUSE_ORDER_BOOKS.ISBN AND 
           WarehouseID = (
                             SELECT Warehouse
                               FROM WAREHOUSE_ORDER
                              WHERE OrderID = WAREHOUSE_ORDER_BOOKS.OrderNo
                         );
END;


-- Trigger: Decrease Warehouse Bookmark Stock
CREATE TRIGGER IF NOT EXISTS [Decrease Warehouse Bookmark Stock]
                       AFTER INSERT
                          ON WAREHOUSE_ORDER_BOOKMARKS
BEGIN
    UPDATE WAREHOUSE_BOOKMARKS
       SET QuantityInStock = QuantityInStock - WAREHOUSE_ORDER_BOOKMARKS.QuantityMoved
     WHERE ProductNo = WAREHOUSE_ORDER_BOOKMARKS.ProductNo AND 
           WarehouseID = (
                             SELECT Warehouse
                               FROM WAREHOUSE_ORDER
                              WHERE OrderID = WAREHOUSE_ORDER_BOOKMARKS.OrderNo
                         );
END;


-- Trigger: Increase Store Book Stock
CREATE TRIGGER IF NOT EXISTS [Increase Store Book Stock]
                       AFTER INSERT
                          ON WAREHOUSE_ORDER_BOOKS
BEGIN
    UPDATE STORE_BOOKKS
       SET QuantityInStock = QuantityInStock + WAREHOUSE_ORDER_BOOKS.QuantityMoved
     WHERE ISBN = WAREHOUSE_ORDER_BOOKS.ISBN AND 
           StoreID = (
                         SELECT Store
                           FROM WAREHOUSE_ORDER
                          WHERE OrderID = WAREHOUSE_ORDER_BOOKS.OrderNo
                     );
END;


-- Trigger: Increase Store Bookmark Stock
CREATE TRIGGER IF NOT EXISTS [Increase Store Bookmark Stock]
                       AFTER INSERT
                          ON WAREHOUSE_ORDER_BOOKMARKS
BEGIN
    UPDATE STORE_BOOKMARKS
       SET QuantityInStock = QuantityInStock + WAREHOUSE_ORDER_BOOKMARKS.QuantityMoved
     WHERE ProductNo = WAREHOUSE_ORDER_BOOKMARKS.ProductNo AND 
           StoreID = (
                         SELECT Store
                           FROM WAREHOUSE_ORDER
                          WHERE OrderID = WAREHOUSE_ORDER_BOOKMARKS.OrderNo
                     );
END;


-- Trigger: Increase Warehouse Book Stock
CREATE TRIGGER IF NOT EXISTS [Increase Warehouse Book Stock]
                       AFTER INSERT
                          ON SUPPLY_ORDER_BOOKS
BEGIN
    UPDATE WAREHOUSE_BOOKS
       SET QuantityInStock = QuantityInStock + SUPPLY_ORDER_BOOKS.QuantityPurchased
     WHERE ISBN = SUPPLY_ORDER_BOOKS.ISBN AND 
           WarehouseID = (
                             SELECT Warehouse
                               FROM SUPPLY_ORDER
                              WHERE OrderID = SUPPLY_ORDER_BOOKS.OrderNo
                         );
END;


-- Trigger: Increase Warehouse Bookmark Stock
CREATE TRIGGER IF NOT EXISTS [Increase Warehouse Bookmark Stock]
                       AFTER INSERT
                          ON SUPPLY_ORDER_BOOKMARKS
BEGIN
    UPDATE WAREHOUSE_BOOKMARKS
       SET QuantityInStock = QuantityInStock + SUPPLY_ORDER_BOOKMARKS.QuantityPurchased
     WHERE ProductNo = SUPPLY_ORDER_BOOKMARKS.ProductNo AND 
           WarehouseID = (
                             SELECT Warehouse
                               FROM SUPPLY_ORDER
                              WHERE OrderID = SUPPLY_ORDER_BOOKMARKS.OrderNo
                         );
END;


-- View: Customer_Book_Totals
CREATE VIEW IF NOT EXISTS Customer_Book_Totals AS
    SELECT O.CustID,
           ROUND(SUM(B.Price * OB.QuantityPurchased), 2) AS BookTotal
      FROM ORDERS O,
           ORDER_BOOKS OB,
           BOOK B
     WHERE O.OrderNo = OB.OrderNo AND 
           OB.ISBN = B.ISBN
     GROUP BY O.CustID;


-- View: Customer_Bookmark_Totals
CREATE VIEW IF NOT EXISTS Customer_Bookmark_Totals AS
    SELECT O.CustID,
           SUM(BM.Price * OBM.QuantityPurchased) AS BookmarkTotal
      FROM ORDERS O,
           ORDER_BOOKMARKS OBM,
           BOOKMARK BM
     WHERE O.OrderNo = OBM.OrderNo AND 
           OBM.ProductNo = BM.ProductNo
     GROUP BY O.CustID;


-- View: Customer_Overall_Total
CREATE VIEW IF NOT EXISTS Customer_Overall_Total AS
    SELECT C.CustomerID,
           C.FNAME,
           C.LNAME,
           ROUND(BT.BookTotal + BMT.BookmarkTotal, 2) AS Total
      FROM CUSTOMER C,
           Customer_Bookmark_Totals AS BMT,
           Customer_Book_Totals AS BT
     WHERE C.CustomerID = BMT.CustID OR 
           C.CustomerID = BT.CustID
     GROUP BY C.CustomerID;


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
