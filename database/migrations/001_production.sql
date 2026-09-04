CREATE EXTENSION IF NOT EXISTS postgis;
CREATE TABLE IF NOT EXISTS drivers (id uuid PRIMARY KEY, name text NOT NULL, available boolean NOT NULL DEFAULT false, location geography(Point,4326), updated_at timestamptz NOT NULL DEFAULT now());
CREATE INDEX IF NOT EXISTS drivers_location_gix ON drivers USING GIST(location);
CREATE TABLE IF NOT EXISTS rides (id uuid PRIMARY KEY, rider_id uuid NOT NULL, driver_id uuid REFERENCES drivers(id), pickup text NOT NULL, destination text NOT NULL, status text NOT NULL CHECK(status IN ('REQUESTED','MATCHED','DRIVER_ARRIVED','IN_PROGRESS','COMPLETED','CANCELLED')), idempotency_key text NOT NULL UNIQUE, created_at timestamptz NOT NULL DEFAULT now(), updated_at timestamptz NOT NULL DEFAULT now());
CREATE INDEX IF NOT EXISTS rides_rider_status_idx ON rides(rider_id,status);
