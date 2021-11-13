-- ex:1
/* Large objects (videos, CAD files, photos, etc.) are stored as:
blob(binary large object) - an object is a large collection of uninterpreted binary data
clob(character large object) - an object is a large collection of symbolic data. *\

-- ex:2
create role accountant;
grant all privileges on accounts, transactions to accountant;
create role administrator;
grant all privileges on accounts, transactions, customers to administrator;
create role support;
grant select, delete, insert on accounts to support;

create user KairatNurtas;
grant accountant to KairatNurtas;
create user ToregaliTorali;
grant administrator to ToregaliTorali;
create user ErkeEsmakhan;
grant support to ErkeEsmakhan;

create role god createtole;
grant god ErkeEsmakhan;
--or
after role support createrole;
revoke delete on accounts from ErkeEsmakhan;

-- ex:3
create assertion sm_curr check
((select currency
  from accounts a join transactions on a.account_id = t.src_account) =
    (select currency
     from accounts a join transactions on a.account_id = t.dst_account));
     
alter table customers alter column birth_date set not null;
ALTER TABLE accounts ALTER COLUMN currency SET NOT null;

-- ex:4
create type val as (sql varchar(3));
alter table accounts alter column currency type val using currency :: val;

-- ex:5
create unique index one_curr on accounts(customer_id, currency);

CREATE INDEX srch_trs ON accounts(currency, balance);

-- wx:6
begin;
update accounts set balance = balance - 500 where account_id = 'NK90123';
savepoint save_point;
update accounts set balance = balance + 500 where account_id = 'AB10203';
rollback to save_point;
commit;
