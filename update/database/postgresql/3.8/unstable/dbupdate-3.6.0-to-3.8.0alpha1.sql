UPDATE ezsite_data SET value='3.8.0alpha1' WHERE name='ezpublish-version';
UPDATE ezsite_data SET value='1' WHERE name='ezpublish-release';

ALTER TABLE ezorder ADD is_archived INT;
UPDATE ezorder SET is_archived='0';
ALTER TABLE ezorder ALTER COLUMN is_archived SET DEFAULT 0;
ALTER TABLE ezorder ALTER COLUMN is_archived SET NOT NULL;
ALTER TABLE ezorder_item ADD type VARCHAR(30);

CREATE INDEX ezorder_is_archived ON ezorder USING btree (is_archived);
CREATE INDEX ezorder_item_type ON ezorder_item USING btree (type);


-- Improved Approval Workflow -- START --
UPDATE ezworkflow_event set data_text3=data_int1;
-- Improved Approval Workflow --  END  --

UPDATE ezpolicy SET function_name='administrate' WHERE module_name='shop' AND function_name='adminstrate';


-- Improved RSS import. -- START --
ALTER TABLE ezrss_import ADD COLUMN import_description text;
ALTER TABLE ezrss_import ALTER import_description SET NOT NULL;
ALTER TABLE ezrss_import ALTER import_description SET DEFAULT '';
-- Improved RSS import. -- END --

-- Multicurrency. -- START --
CREATE SEQUENCE ezcurrencydata_s
    START 1
    INCREMENT 1
    MAXVALUE 9223372036854775807
    MINVALUE 1
    CACHE 1;


CREATE TABLE ezcurrencydata (
  id integer NOT NULL DEFAULT nextval('ezcurrencydata_s'::text),
  code varchar(4) NOT NULL default '',
  symbol varchar(255) NOT NULL default '',
  locale varchar(255) NOT NULL default '',
  status integer NOT NULL default 1,
  auto_rate_value numeric(10,5) NOT NULL default '0.00000',
  custom_rate_value numeric(10,5) NOT NULL default '0.00000',
  rate_factor numeric(10,5) NOT NULL default '1.00000'
);

ALTER TABLE ONLY ezcurrencydata
    ADD CONSTRAINT ezcurrencydata_pkey PRIMARY KEY (id);

CREATE INDEX ezcurrencydata_code ON ezcurrencydata USING btree (code);


CREATE SEQUENCE ezmultipricedata_s
    START 1
    INCREMENT 1
    MAXVALUE 9223372036854775807
    MINVALUE 1
    CACHE 1;

CREATE TABLE ezmultipricedata (
  id integer NOT NULL DEFAULT nextval('ezmultipricedata_s'::text),
  contentobject_attr_id integer NOT NULL default 0,
  contentobject_attr_version integer NOT NULL default 0,
  currency_code varchar(4) NOT NULL default '',
  value numeric(15,2) NOT NULL default '0.00',
  type integer NOT NULL default 0
);

ALTER TABLE ONLY ezmultipricedata
    ADD CONSTRAINT ezmultipricedata_pkey PRIMARY KEY (id);

CREATE INDEX ezmultipricedata_coa_id ON ezmultipricedata USING btree (contentobject_attr_id);
CREATE INDEX ezmultipricedata_coa_version ON ezmultipricedata USING btree (contentobject_attr_version);
CREATE INDEX ezmultipricedata_currency_code ON ezmultipricedata USING btree (currency_code);


ALTER TABLE ezproductcollection ADD currency_code varchar(4);
ALTER TABLE ezproductcollection ALTER currency_code SET NOT NULL;
ALTER TABLE ezproductcollection ALTER currency_code SET DEFAULT '';
-- Multicurrency. -- END --

-- Improved packages system -- START --
CREATE SEQUENCE ezpackage_s
       START 1
       INCREMENT 1
       MAXVALUE 9223372036854775807
       MINVALUE 1
       CACHE 1;

CREATE TABLE ezpackage (
  id integer NOT NULL DEFAULT nextval('ezpackage_s'::text),
  name varchar(100) NOT NULL default '',
  version varchar(30) NOT NULL default '0',
  install_date integer NOT NULL,
  PRIMARY KEY  (id)
);
-- Improved packages system -- END --

-- VAT charging rules -- START --
CREATE SEQUENCE ezproductcategory_s;
CREATE TABLE ezproductcategory (
  id INTEGER NOT NULL DEFAULT nextval('ezproductcategory_s'),
  name VARCHAR(255) NOT NULL default '',
  PRIMARY KEY (id)
);

CREATE SEQUENCE ezvatrule_s;
CREATE TABLE ezvatrule (
  id INTEGER NOT NULL DEFAULT nextval('ezvatrule_s'),
  country VARCHAR(255) NOT NULL default '',
  vat_type INTEGER NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE ezvatrule_product_category (
  vatrule_id INTEGER NOT NULL,
  product_category_id INTEGER NOT NULL
);

ALTER TABLE ONLY ezvatrule_product_category
    ADD CONSTRAINT ezvatrule_product_category_pkey PRIMARY KEY (vatrule_id, product_category_id);
-- VAT charging rules -- END --
