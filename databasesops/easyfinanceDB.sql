CREATE TABLE user(
    id_user INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
    email_address VARCHAR(80) NOT NULL,
    fname VARCHAR(25) NOT NULL,
    lname VARCHAR(25) NOT NULL,
    login_state BOOLEAN NOT NULL,
    attemptsIncorr TINYINT(2) NOT NULL,
    dateIncorr DATETIME NOT NULL,
    type_user ENUM('admin','customer') NOT NULL,
    last_login DATETIME NOT NULL,
    PRIMARY KEY(id_user),
    UNIQUE email_i (email_address)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE customer (
    id_customer INT(10) UNSIGNED NULL AUTO_INCREMENT,
    id_user INT(10) UNSIGNED NOT NULL, 
    username_cust VARCHAR(20) NOT NULL ,
    documentNum_cust VARCHAR(15) NOT NULL ,
    address_cust VARCHAR(30) NULL DEFAULT NULL ,
    phoneNum_cust VARCHAR(15) NOT NULL ,
    password_cust VARCHAR(20) NOT NULL ,
    dataReg_cust DATE NOT NULL ,
    city_cust VARCHAR(20) NULL DEFAULT NULL ,
    country_cust VARCHAR(20) NULL DEFAULT NULL ,
    PRIMARY KEY (id_customer),
    UNIQUE username_cu (username_cust),
    FOREIGN KEY (id_user)
      REFERENCES user(id_user)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_unicode_ci;


CREATE TABLE admin (
    id_admin int(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    id_user INT(10) UNSIGNED NOT NULL, 
    username_admin varchar(20) COLLATE utf8_unicode_ci NOT NULL,
    oauth_token int(5) UNSIGNED NOT NULL,
    password_admin varchar(20) COLLATE utf8_unicode_ci NOT NULL,
    PRIMARY KEY (id_admin),
    UNIQUE username_ad (username_admin),
    FOREIGN KEY (id_user)
        REFERENCES user(id_user)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE bank (
    id_bank INT(5) NOT NULL AUTO_INCREMENT ,
    name_bank VARCHAR(20) NOT NULL ,
    securityContact VARCHAR(20) NOT NULL ,
    infoNumber VARCHAR(15) NOT NULL ,
    PRIMARY KEY (id_bank),
    UNIQUE namebank_i (name_bank)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_unicode_ci;


CREATE TABLE account (
    id_acc INT(10) NOT NULL AUTO_INCREMENT,
    id_bank INT(5) NOT NULL, 
    id_customer INT(10) UNSIGNED NULL, 
    id_currency TINYINT(5) NOT NULL, 
    number_acc INT(20) NOT NULL,
    state_acc BOOLEAN NOT NULL,
    type_acc ENUM('credit','current','investment','loan','saving') NOT NULL,
    regDate_acc DATE NOT NULL,
    regDateOpen_acc DATE NOT NULL,
    regDateClose_acc DATE NOT NULL,
    PRIMARY KEY (id_acc),
    FOREIGN KEY (id_bank)
        REFERENCES bank(id_bank)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_customer)
        REFERENCES customer(id_customer)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_currency)
        REFERENCES currency(id_currency)
        --ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE investmentAcc (
    id_investment INT(8) NOT NULL AUTO_INCREMENT,
    id_acc INT(10) NOT NULL, 
    investment_amount DECIMAL(15,2) NOT NULL,
    investment_descrip VARCHAR(15) NULL DEFAULT NULL,
    investment_date DATE NOT NULL,
    confirm_authcode INT NOT NULL,
    minamount_protect VARCHAR(15),
    profit_win DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (id_investment),
    FOREIGN KEY (id_acc)
        REFERENCES account(id_acc)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE creditAcc (
    id_creditAcc INT(8) NOT NULL AUTO_INCREMENT,
    id_acc INT(10) NOT NULL, 
    account_name VARCHAR(15) NOT NULL,
    expiration_date DATE NOT NULL,
    biling_address VARCHAR(20) NOT NULL,
    accDescrip VARCHAR(20) NULL DEFAULT NULL,
    PRIMARY KEY (id_creditAcc),
    FOREIGN KEY (id_acc)
        REFERENCES account(id_acc)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE savingAcc (
    id_saving INT(8) NOT NULL AUTO_INCREMENT,
    id_acc INT(10) NOT NULL, 
    special_rate DECIMAL(5,2) NOT NULL, 
    stdr_rate DECIMAL(5,2) NOT NULL,
    handling_fees DECIMAL(5,2) NOT NULL,
    operation_cost INT(8) NOT NULL,
    PRIMARY KEY (id_saving),
    FOREIGN KEY (id_acc)
        REFERENCES account(id_acc)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE loanAcc (
    id_loan INT(8) NOT NULL AUTO_INCREMENT,
    id_acc INT(10) NOT NULL, 
    loan_name VARCHAR(15) NOT NULL,
    loan_descrip VARCHAR(15) NOT NULL,
    loan_amount DECIMAL(15,2) NOT NULL,
    handling_fees DECIMAL(5,2) NOT NULL,
    interest_rate DECIMAL (5,2) NOT NULL,
    PRIMARY KEY (id_loan),
    FOREIGN KEY (id_acc)
        REFERENCES account(id_acc)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE currentAcc (
    id_currentAcc INT(8) NOT NULL AUTO_INCREMENT,
    id_acc INT(10) NOT NULL, 
    bank_checknumber INT(20) NOT NULL,
    date_ofsign DATE NOT NULL,
    nameReceiver VARCHAR(20) NOT NULL,
    expiratDate_check DATE NOT NULL,
    PRIMARY KEY (id_currentAcc),
    FOREIGN KEY (id_acc)
        REFERENCES account(id_acc)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE transaction (
    id_trans INT(15) NOT NULL AUTO_INCREMENT,
    id_currency TINYINT(5) NOT NULL, 
    id_acc INT(10) NOT NULL, 
    totalAmount_trans DECIMAL(15,2) NOT NULL,
    date_trans DATE NOT NULL,
    time_trans TIME NOT NULL,
    receiver_account VARCHAR(20) NOT NULL,
    descrip_trans VARCHAR(20) NULL DEFAULT NULL,
    PRIMARY KEY (id_trans),
    FOREIGN KEY (id_currency)
        REFERENCES currency(id_currency),
        --ON UPDATE CASCADE ON DELETE CASCADE
    FOREIGN KEY (id_acc)
        REFERENCES account(id_acc)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE transactionTemplate (
    id_template INT(15) NOT NULL AUTO_INCREMENT,
    id_trans INT(15) NOT NULL, 
    name_template VARCHAR(15) NOT NULL,
    descrip_template VARCHAR(15) NULL DEFAULT NULL,
    PRIMARY KEY (id_template),
    UNIQUE nameTemplate_i (name_template)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE receipt (
    id_receipt INT(15) NOT NULL AUTO_INCREMENT,
    id_trans INT(15) NOT NULL, 
    descrip_receipt VARCHAR(15) NULL DEFAULT NULL,
    urlPhoto_receipt VARCHAR(40) NOT NULL,
    PRIMARY KEY (id_receipt),
    FOREIGN KEY (id_trans)
        REFERENCES transaction(id_trans)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE currency (
    id_currency TINYINT(5) NOT NULL AUTO_INCREMENT,
    name_currency VARCHAR(12) NOT NULL,
    PRIMARY KEY (id_currency),
    UNIQUE nameCurrency_i(name_currency)
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE groupAcc (
    id_groupAcc INT(8) NOT NULL AUTO_INCREMENT,
    id_currency TINYINT(5) NOT NULL, 
    name_groupAcc VARCHAR(12) NOT NULL,
    PRIMARY KEY (id_groupAcc),
    UNIQUE nameGroup_i(name_groupAcc),
    FOREIGN KEY (id_currency)
        REFERENCES currency(id_currency)
        --ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE itemGroup (
    id_itemGroup INT(8) NOT NULL AUTO_INCREMENT,
    id_groupAcc INT(8) NOT NULL, 
    id_acc INT(10) NOT NULL, 
    PRIMARY KEY (id_itemGroup),
    FOREIGN KEY (id_groupAcc)
        REFERENCES groupAcc(id_groupAcc)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_acc)
        REFERENCES account(id_acc)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE budget (
    id_budget INT(8) NOT NULL AUTO_INCREMENT,
    id_currency TINYINT(5) NOT NULL, 
    name_budget VARCHAR(12) NOT NULL,
    type_budget VARCHAR(12) NOT NULL,
    recurrency_budget BOOLEAN DEFAULT 0,
    descrip_budget VARCHAR(15) NULL DEFAULT NULL,
    totalAmount_budget INT(15),
    dateInit_budget DATE NULL DEFAULT NULL,
    dateEnd_budget DATE NULL DEFAULT NULL,
    PRIMARY KEY (id_budget),
    UNIQUE nameBudget_i(name_budget),
    FOREIGN KEY (id_currency)
        REFERENCES currency(id_currency)
        --ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE itemBudget (
    id_itemBudget INT(8) NOT NULL AUTO_INCREMENT,
    id_budget INT(8) NOT NULL, 
    id_acc INT(10) NOT NULL, 
    PRIMARY KEY (id_itemBudget),
    FOREIGN KEY (id_budget)
        REFERENCES budget(id_budget)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_acc)
        REFERENCES account(id_acc)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


/*
ALTER TABLE customer
    ADD KEY fk_id_user (id_user),
    ADD CONSTRAINT fk_id_user FOREIGN KEY
    (id_user) REFERENCES user (id_user)
    ON DELETE CASCADE
    ON UPDATE CASCADE


ALTER TABLE customer
    ADD CONSTRAINT FK_customerUser
    FOREIGN KEY (id_user) REFERENCES user(id_user);
*/