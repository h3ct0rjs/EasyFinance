/* registro de usuarios customer*/
INSERT INTO user (email_address, fname, lname, login_state, attemptsIncorr, dateIncorr, type_user, last_login)
	VALUES ('kam@gmail.com','kevin','moreno',true,0,'1000-01-01 00:00:00','customer','1000-01-01 00:00:00');

INSERT INTO customer (id_user, username_cust, documentNum_cust, address_cust, phoneNum_cust, password_cust, dataReg_cust, city_cust, country_cust)
	VALUES ((SELECT id_user FROM user WHERE email_address='kam@gmail.com'), 'kam01','64641','cra 10', '311', '123abc', (SELECT CURDATE()), 'Pereira','Colombia');

/* eliminar usuario customer*/
DELETE FROM user WHERE email_address='kam@gmail.com' AND type_user='customer';

----------------------------------------------------------------------------

/* registro de usuarios admin*/
INSERT INTO user (email_address, fname, lname, login_state, attemptsIncorr, dateIncorr, type_user, last_login)
	VALUES ('hfj@gmail.com','hector','jimenez',true,0,'1000-01-01 00:00:00','admin','1000-01-01 00:00:00');

INSERT INTO admin (id_user, username_admin, oauth_token, password_admin)
	VALUES ((SELECT id_user FROM user WHERE email_address='hfj@gmail.com'), 'hfj01','12345','pass');

/* eliminar usuario admin*/
DELETE FROM user WHERE email_address='hfj@gmail.com' AND type_user='admin';
----------------------------------------------------------------------------

/* obtener id_user */
SELECT id_user FROM user
	WHERE email_address='kam@gmail.com';

----------------------------------------------------------------------------

/* agregar bancos*/
INSERT INTO bank (name_bank, securityContact, infoNumber) VALUES ('Mi Banco', 'Pepe','312312');

----------------------------------------------------------------------------

/* agregar monedas*/
INSERT INTO currency (name_currency) VALUES ('Dollar');
INSERT INTO currency (name_currency) VALUES ('Euro');
INSERT INTO currency (name_currency) VALUES ('Pesos COL');

----------------------------------------------------------------------------

/* agregar cuentas de inversion*/
INSERT INTO account (id_bank, id_customer, id_currency, number_acc, state_acc, type_acc, regDate_acc, regDateOpen_acc, regDateClose_acc)
	VALUES ((SELECT id_bank FROM bank WHERE name_bank='Mi Banco'), (SELECT id_user FROM customer WHERE username_cust='kam01'), (SELECT id_currency FROM currency WHERE name_currency='Dollar'), 1111111110, true, 'investment', '1000-01-01', '1000-01-01', '1000-01-01');

INSERT INTO investmentAcc (id_acc, investment_amount, investment_descrip, investment_date, confirm_authcode, minamount_protect, profit_win)
	VALUES ((SELECT id_acc FROM account WHERE type_acc='investment' AND number_acc=2147483647), 5000, 'Acciones', '2018-05-01', 123, 2000, 580);

/* eliminar cuentas de inversion*/
DELETE FROM account WHERE number_acc=1111111110 AND type_acc='investment';

----------------------------------------------------------------------------

/* agregar cuentas de credito*/
INSERT INTO account (id_bank, id_customer, id_currency, number_acc, state_acc, type_acc, regDate_acc, regDateOpen_acc, regDateClose_acc)
	VALUES ((SELECT id_bank FROM bank WHERE name_bank='Mi Banco'), (SELECT id_user FROM customer WHERE username_cust='kam01'), (SELECT id_currency FROM currency WHERE name_currency='Euro'), 1111111111, true, 'credit', '1000-01-01', '1000-01-01', '1000-01-01');

INSERT INTO creditAcc (id_acc, account_name, expiration_date, biling_address, accDescrip)
	VALUES ((SELECT id_acc FROM account WHERE type_acc='credit' AND number_acc=1111111111), 'Mi credito', '2021-01-01', 'Cra 10 # 20-40', 'Credito');

/* eliminar cuentas de credito*/
DELETE FROM account WHERE number_acc=1111111111 AND type_acc='credit';

----------------------------------------------------------------------------

/* agregar cuentas de ahorro*/
INSERT INTO account (id_bank, id_customer, id_currency, number_acc, state_acc, type_acc, regDate_acc, regDateOpen_acc, regDateClose_acc)
	VALUES ((SELECT id_bank FROM bank WHERE name_bank='Mi Banco'), (SELECT id_user FROM customer WHERE username_cust='kam01'), (SELECT id_currency FROM currency WHERE name_currency='Pesos COL'), 1111111112, true, 'saving', '1000-01-01', '1000-01-01', '1000-01-01');

INSERT INTO savingAcc (id_acc, special_rate, stdr_rate, handling_fees, operation_cost)
	VALUES ((SELECT id_acc FROM account WHERE type_acc='saving' AND number_acc=1111111112), 1.5, 2, 30, 900);

/* eliminar cuentas de ahorro*/
DELETE FROM account WHERE number_acc=1111111112 AND type_acc='saving';

----------------------------------------------------------------------------

/* agregar cuentas de prestamo*/
INSERT INTO account (id_bank, id_customer, id_currency, number_acc, state_acc, type_acc, regDate_acc, regDateOpen_acc, regDateClose_acc)
	VALUES ((SELECT id_bank FROM bank WHERE name_bank='Mi Banco'), (SELECT id_user FROM customer WHERE username_cust='kam01'), (SELECT id_currency FROM currency WHERE name_currency='Pesos COL'), 1111111113, true, 'loan', '1000-01-01', '1000-01-01', '1000-01-01');

INSERT INTO loanAcc (id_acc, loan_name, loan_descrip, loan_amount, handling_fees, interest_rate)
	VALUES ((SELECT id_acc FROM account WHERE type_acc='loan' AND number_acc=1111111113), 'nombre prestamo', 'descripcion', 25000000, 900, 0.95);

/* eliminar cuentas de prestamo*/
DELETE FROM account WHERE number_acc=1111111113 AND type_acc='loan';

----------------------------------------------------------------------------

/* agregar cuentas de prestamo*/
INSERT INTO account (id_bank, id_customer, id_currency, number_acc, state_acc, type_acc, regDate_acc, regDateOpen_acc, regDateClose_acc)
	VALUES ((SELECT id_bank FROM bank WHERE name_bank='Mi Banco'), (SELECT id_user FROM customer WHERE username_cust='kam01'), (SELECT id_currency FROM currency WHERE name_currency='Dollar'), 1111111114, true, 'current', '1000-01-01', '1000-01-01', '1000-01-01');

INSERT INTO currentAcc (id_acc, bank_checknumber, date_ofsign, nameReceiver, expiratDate_check)
	VALUES ((SELECT id_acc FROM account WHERE type_acc='current' AND number_acc=1111111114), 77777777, '1000-01-01','Pepe', '1000-01-01');

/* eliminar cuentas de prestamo*/
DELETE FROM account WHERE number_acc=1111111114 AND type_acc='current';

----------------------------------------------------------------------------

/* verificar login */
SELECT email_address, password_cust FROM user, customer
WHERE user.id_user=customer.id_user
AND email_address=--email
AND password_cust=--pass

----------------------------------------------------------------------------

/* obtener cuentas del usuario */
CREATE VIEW accountsUser AS
SELECT  id_user, name_bank, number_acc, type_acc, regDate_acc FROM bank, account, customer
WHERE account.id_bank=bank.id_bank
AND account.id_customer=customer.id_customer
ORDER BY type_acc;

SELECT * FROM accountsUser WHERE id_user=$$;
SELECT * FROM accountsUser WHERE id_user=$$ AND type_acc='credit';
SELECT * FROM accountsUser WHERE id_user=$$ AND type_acc='current';
SELECT * FROM accountsUser WHERE id_user=$$ AND type_acc='saving';
 
----------------------------------------------------------------------------


/* actualizar usuarios customer*/
CREATE PROCEDURE `updateUser`(IN `id_userUpdate` INT(10), IN `new_email` VARCHAR(80), IN `new_fname` VARCHAR(25), IN `new_lname` VARCHAR(25), IN `new_username` VARCHAR(20), IN `new_documentNum` VARCHAR(15), IN `new_address` VARCHAR(30), IN `new_phoneNum` VARCHAR(15), IN `new_city` VARCHAR(20), IN `new_country` VARCHAR(20)) NOT DETERMINISTIC MODIFIES SQL DATA SQL SECURITY DEFINER BEGIN
IF new_email!='' THEN UPDATE user SET email_address=new_email WHERE id_user=id_userUpdate;
END IF;
IF new_fname!='' THEN UPDATE user SET fname=new_fname WHERE id_user=id_userUpdate;
END IF;
IF new_lname!='' THEN UPDATE user SET lname=new_lname WHERE id_user=id_userUpdate;
END IF;
IF new_username!='' THEN UPDATE customer SET username_cust=new_username WHERE id_user=id_userUpdate;
END IF;
IF new_documentNum!='' THEN UPDATE customer SET documentNum_cust=new_documentNum WHERE id_user=id_userUpdate;
END IF;
IF new_address!='' THEN UPDATE customer SET address_cust=new_address WHERE id_user=id_userUpdate;
END IF;
IF new_phoneNum!='' THEN UPDATE customer SET phoneNum_cust=new_phoneNum  WHERE id_user=id_userUpdate;
END IF;
IF new_city!='' THEN UPDATE customer SET city_cust=new_city  WHERE id_user=id_userUpdate;
END IF;
IF new_country!='' THEN UPDATE customer SET country_cust=new_country  WHERE id_user=id_userUpdate;
END IF;
END
