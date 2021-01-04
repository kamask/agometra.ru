CREATE TABLE callback (
    id serial,
    created_at timestamptz(0) NULL DEFAULT CURRENT_TIMESTAMP,
    "number" varchar(12) NULL,
    CONSTRAINT callback_pkey PRIMARY KEY (id)
);

CREATE TABLE clients (
    id serial,
    "name" varchar(50) NULL,
    "number" varchar(12) NULL,
    created_at timestamptz(0) NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT clients_pk PRIMARY KEY (id),
    CONSTRAINT clients_un UNIQUE (number)
);

CREATE TABLE colors (
    id serial,
    "name" varchar(50) NULL,
    code varchar(2) NULL,
    hex varchar(6) NULL,
    CONSTRAINT colors_name_key UNIQUE (name),
    CONSTRAINT colors_pkey PRIMARY KEY (id)
);

CREATE TABLE density (
    id serial,
    code int2 NULL,
    price float4 NULL,
    price_100 float4 NULL,
    price_1000 float4 NULL,
    CONSTRAINT density_pk PRIMARY KEY (id)
);

CREATE TABLE gallery_agometra (
    id serial,
    url varchar NULL,
    "desc" text NULL,
    CONSTRAINT gallery_agometra_pkey PRIMARY KEY (id)
);

CREATE TABLE sizes (
    id serial,
    "name" varchar(30) NULL,
    code varchar(30) NULL,
    euro varchar(30) NULL,
    CONSTRAINT sizes_pk PRIMARY KEY (id)
);

CREATE TABLE exact_sizes (
    id serial,
    density_id int4 NULL,
    size_id int4 NULL,
    a int2 NULL,
    b int2 NULL,
    c int2 NULL,
    d int2 NULL,
    CONSTRAINT exact_sizes_pk PRIMARY KEY (id),
    CONSTRAINT exact_size_fk_density FOREIGN KEY (density_id) REFERENCES density(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT exact_size_fk_sizes FOREIGN KEY (size_id) REFERENCES sizes(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE orders (
    id serial,
    client_id int4 NULL,
    created_at timestamptz(0) NULL DEFAULT CURRENT_TIMESTAMP,
    one_click bool NULL DEFAULT false,
    CONSTRAINT orders_pk PRIMARY KEY (id),
    CONSTRAINT orders_fk_clients FOREIGN KEY (client_id) REFERENCES clients(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE photos_shirts (
    id serial,
    url_jpg varchar NULL,
    density_id int4 NULL,
    color_id int4 NULL,
    url_webp varchar NULL,
    CONSTRAINT photos_shirts_pk PRIMARY KEY (id),
    CONSTRAINT photos_shirts_fk FOREIGN KEY (color_id) REFERENCES colors(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT photos_shirts_fk_1 FOREIGN KEY (density_id) REFERENCES density(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE shirts (
    id serial,
    article varchar(7) NULL,
    count int4 NULL,
    density_id int4 NULL,
    color_id int4 NULL,
    size_id int4 NULL,
    CONSTRAINT shirts_pk PRIMARY KEY (id),
    CONSTRAINT shirts_un UNIQUE (article),
    CONSTRAINT shirts_color_fk FOREIGN KEY (color_id) REFERENCES colors(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT shirts_density_fk FOREIGN KEY (density_id) REFERENCES density(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT shirts_size_fk FOREIGN KEY (size_id) REFERENCES sizes(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE expected (
    id serial,
    shirt_id int4 NULL,
    count int4 NULL,
    "date" timestamptz(0) NULL,
    CONSTRAINT expected_pk PRIMARY KEY (id),
    CONSTRAINT expected_fk FOREIGN KEY (shirt_id) REFERENCES shirts(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE orders_shirts_list (
    id serial,
    order_id int4 NULL,
    shirt_id int4 NULL,
    created_at timestamptz(0) NULL DEFAULT CURRENT_TIMESTAMP,
    count int4 NULL,
    CONSTRAINT orders_shirts_list_pk PRIMARY KEY (id),
    CONSTRAINT orders_shirts_list_fk_orders FOREIGN KEY (order_id) REFERENCES orders(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT orders_shirts_list_fk_shirts FOREIGN KEY (shirt_id) REFERENCES shirts(id) ON UPDATE CASCADE ON DELETE CASCADE
);
