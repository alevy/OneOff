CREATE TABLE addresses (
  address VARCHAR(500) NOT NULL,
  destination VARCHAR(500) NOT NULL,
  origin VARCHAR(500)
);

CREATE UNIQUE INDEX idx_address on addresses(address);
