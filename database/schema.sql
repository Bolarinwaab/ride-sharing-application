CREATE TABLE riders (id UUID PRIMARY KEY, name TEXT NOT NULL, email TEXT UNIQUE NOT NULL, created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE drivers (id UUID PRIMARY KEY, name TEXT NOT NULL, status TEXT NOT NULL CHECK (status IN ('offline','available','busy')), created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE TABLE rides (id UUID PRIMARY KEY, rider_id UUID NOT NULL REFERENCES riders(id), driver_id UUID REFERENCES drivers(id), pickup TEXT NOT NULL, destination TEXT NOT NULL, status TEXT NOT NULL CHECK (status IN ('requested','matched','accepted','in_progress','completed','cancelled')), fare NUMERIC(10,2), created_at TIMESTAMPTZ NOT NULL DEFAULT now());
CREATE INDEX rides_rider_idx ON rides(rider_id, created_at DESC);
CREATE INDEX rides_driver_idx ON rides(driver_id, created_at DESC);
