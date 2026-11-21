-- KlinikSihat Enterprise Data Warehouse: star schema DDL (PostgreSQL)
-- Grain: one row in fact_appointment per scheduled appointment.

CREATE TABLE dim_date (
    date_key            INTEGER      PRIMARY KEY,      -- surrogate key, format YYYYMMDD
    full_date           DATE         NOT NULL UNIQUE,
    day_of_month        SMALLINT     NOT NULL,
    day_name            VARCHAR(9)   NOT NULL,
    day_of_week         SMALLINT     NOT NULL,          -- 1 = Monday ... 7 = Sunday
    is_weekend          BOOLEAN      NOT NULL,
    is_public_holiday   BOOLEAN      NOT NULL,
    month_num           SMALLINT     NOT NULL,
    month_name          VARCHAR(9)   NOT NULL,
    quarter_num         SMALLINT     NOT NULL,
    year_num            SMALLINT     NOT NULL
);

CREATE TABLE dim_time_slot (
    time_slot_key       SMALLINT     PRIMARY KEY,
    slot_start          TIME         NOT NULL,
    slot_end            TIME         NOT NULL,
    hour_of_day         SMALLINT     NOT NULL,
    session_name        VARCHAR(10)  NOT NULL           -- Morning / Afternoon / Evening
);

CREATE TABLE dim_patient (
    patient_key         INTEGER      PRIMARY KEY,      -- surrogate key (one per version)
    patient_id          VARCHAR(12)  NOT NULL,          -- natural key from the EMR
    ic_hash             CHAR(64)     NOT NULL,          -- salted SHA-256 of MyKad number
    gender              CHAR(1),
    birth_year          SMALLINT,
    postcode            CHAR(5),
    district            VARCHAR(50),
    state               VARCHAR(30),
    insurance_type      VARCHAR(20),                    -- Self-pay / Panel / Insurance
    effective_from      DATE         NOT NULL,          -- SCD Type 2 tracking columns
    effective_to        DATE         NOT NULL DEFAULT '9999-12-31',
    is_current          BOOLEAN      NOT NULL DEFAULT TRUE
);

CREATE TABLE dim_doctor (
    doctor_key          INTEGER      PRIMARY KEY,
    doctor_id           VARCHAR(10)  NOT NULL,
    doctor_name         VARCHAR(100) NOT NULL,
    specialty           VARCHAR(40)  NOT NULL,
    gender              CHAR(1),
    employment_type     VARCHAR(10)  NOT NULL,          -- Permanent / Locum
    experience_band     VARCHAR(10)
);

CREATE TABLE dim_clinic (
    clinic_key          SMALLINT     PRIMARY KEY,
    clinic_code         VARCHAR(6)   NOT NULL,
    clinic_name         VARCHAR(80)  NOT NULL,
    district            VARCHAR(50)  NOT NULL,
    state               VARCHAR(30)  NOT NULL,
    region              VARCHAR(20)  NOT NULL,
    opened_date         DATE,
    consultation_rooms  SMALLINT
);

CREATE TABLE dim_booking_channel (
    channel_key         SMALLINT     PRIMARY KEY,
    channel_name        VARCHAR(20)  NOT NULL,          -- Mobile App / WhatsApp / Phone / Website / Walk-in
    channel_type        VARCHAR(12)  NOT NULL           -- Digital / Assisted
);

CREATE TABLE fact_appointment (
    appointment_key         BIGINT        PRIMARY KEY,
    appointment_no          VARCHAR(15)   NOT NULL,     -- degenerate dimension
    appt_date_key           INTEGER       NOT NULL,
    booking_date_key        INTEGER       NOT NULL,
    time_slot_key           SMALLINT      NOT NULL,
    patient_key             INTEGER       NOT NULL,
    doctor_key              INTEGER       NOT NULL,
    clinic_key              SMALLINT      NOT NULL,
    channel_key             SMALLINT      NOT NULL,
    consultation_fee_rm     DECIMAL(8,2)  NOT NULL,     -- additive
    no_show_flag            SMALLINT      NOT NULL CHECK (no_show_flag IN (0, 1)),  -- additive
    reminders_sent          SMALLINT      NOT NULL DEFAULT 0,                       -- additive
    outstanding_balance_rm  DECIMAL(10,2) NOT NULL DEFAULT 0,                       -- semi-additive
    panel_coverage_pct      DECIMAL(5,2)  CHECK (panel_coverage_pct BETWEEN 0 AND 100), -- non-additive
    CONSTRAINT fk_appt_date    FOREIGN KEY (appt_date_key)    REFERENCES dim_date (date_key),
    CONSTRAINT fk_booking_date FOREIGN KEY (booking_date_key) REFERENCES dim_date (date_key),
    CONSTRAINT fk_time_slot    FOREIGN KEY (time_slot_key)    REFERENCES dim_time_slot (time_slot_key),
    CONSTRAINT fk_patient      FOREIGN KEY (patient_key)      REFERENCES dim_patient (patient_key),
    CONSTRAINT fk_doctor       FOREIGN KEY (doctor_key)       REFERENCES dim_doctor (doctor_key),
    CONSTRAINT fk_clinic       FOREIGN KEY (clinic_key)       REFERENCES dim_clinic (clinic_key),
    CONSTRAINT fk_channel      FOREIGN KEY (channel_key)      REFERENCES dim_booking_channel (channel_key)
);
