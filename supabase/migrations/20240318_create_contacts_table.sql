-- Create enum types for subscription statuses and buyer preferences
CREATE TYPE subscription_status AS ENUM ('subscribed', 'unsubscribed', 'pending', 'bounced');
CREATE TYPE buyer_preference AS ENUM ('email', 'phone', 'both', 'none');

-- Create the contacts table
CREATE TABLE contacts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Name fields
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    
    -- Contact information
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20),
    mobile VARCHAR(20),
    
    -- Company information
    company VARCHAR(200),
    
    -- Address information
    street_address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    zip_postcode VARCHAR(20),
    country VARCHAR(100),
    
    -- Subscription information
    subscription_date TIMESTAMP WITH TIME ZONE,
    unsubscription_date TIMESTAMP WITH TIME ZONE,
    unsubscribed_reason TEXT,
    subscription_status_email subscription_status DEFAULT 'pending',
    subscription_status_sms subscription_status DEFAULT 'pending',
    
    -- Source tracking
    source VARCHAR(100),
    site_source VARCHAR(100),
    sub_source VARCHAR(100),
    
    -- Additional information
    buyer_preference buyer_preference DEFAULT 'email',
    birthday DATE,
    latest_interaction TIMESTAMP WITH TIME ZONE,
    
    -- Metadata
    tags TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT valid_phone CHECK (phone ~* '^\+?[0-9\s\-()]{10,20}$'),
    CONSTRAINT valid_mobile CHECK (mobile ~* '^\+?[0-9\s\-()]{10,20}$'),
    CONSTRAINT valid_zip CHECK (zip_postcode ~* '^[A-Z0-9\s\-]{3,20}$')
);

-- Create indexes for frequently queried columns
CREATE INDEX idx_contacts_email ON contacts(email);
CREATE INDEX idx_contacts_phone ON contacts(phone);
CREATE INDEX idx_contacts_mobile ON contacts(mobile);
CREATE INDEX idx_contacts_company ON contacts(company);
CREATE INDEX idx_contacts_subscription_status_email ON contacts(subscription_status_email);
CREATE INDEX idx_contacts_subscription_status_sms ON contacts(subscription_status_sms);
CREATE INDEX idx_contacts_tags ON contacts USING GIN(tags);
CREATE INDEX idx_contacts_created_at ON contacts(created_at);
CREATE INDEX idx_contacts_updated_at ON contacts(updated_at);

-- Create a function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create a trigger to automatically update the updated_at column
CREATE TRIGGER update_contacts_updated_at
    BEFORE UPDATE ON contacts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Create a function to handle tag updates
CREATE OR REPLACE FUNCTION update_contact_tags()
RETURNS TRIGGER AS $$
BEGIN
    -- Ensure tags are unique and lowercase
    NEW.tags := array(
        SELECT DISTINCT lower(tag)
        FROM unnest(NEW.tags) AS tag
        WHERE tag IS NOT NULL AND tag != ''
    );
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create a trigger to handle tag updates
CREATE TRIGGER update_contacts_tags
    BEFORE INSERT OR UPDATE ON contacts
    FOR EACH ROW
    EXECUTE FUNCTION update_contact_tags();

-- Add RLS (Row Level Security) policies
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

-- Create a policy that allows all operations for authenticated users
CREATE POLICY "Allow all operations for authenticated users"
    ON contacts
    FOR ALL
    TO authenticated
    USING (true)
    WITH CHECK (true);

-- Create a policy that allows read-only access for anon users
CREATE POLICY "Allow read-only access for anon users"
    ON contacts
    FOR SELECT
    TO anon
    USING (true);

-- Add comments to the table and columns for documentation
COMMENT ON TABLE contacts IS 'Stores contact information for CRM system';
COMMENT ON COLUMN contacts.id IS 'Unique identifier for the contact';
COMMENT ON COLUMN contacts.first_name IS 'Contact''s first name';
COMMENT ON COLUMN contacts.last_name IS 'Contact''s last name';
COMMENT ON COLUMN contacts.email IS 'Contact''s email address (must be valid format)';
COMMENT ON COLUMN contacts.phone IS 'Contact''s landline phone number';
COMMENT ON COLUMN contacts.mobile IS 'Contact''s mobile phone number';
COMMENT ON COLUMN contacts.company IS 'Contact''s company name';
COMMENT ON COLUMN contacts.street_address IS 'Contact''s street address';
COMMENT ON COLUMN contacts.city IS 'Contact''s city';
COMMENT ON COLUMN contacts.state IS 'Contact''s state/province';
COMMENT ON COLUMN contacts.zip_postcode IS 'Contact''s ZIP or postal code';
COMMENT ON COLUMN contacts.country IS 'Contact''s country';
COMMENT ON COLUMN contacts.subscription_date IS 'Date when the contact subscribed';
COMMENT ON COLUMN contacts.unsubscription_date IS 'Date when the contact unsubscribed';
COMMENT ON COLUMN contacts.unsubscribed_reason IS 'Reason for unsubscription';
COMMENT ON COLUMN contacts.subscription_status_email IS 'Email subscription status';
COMMENT ON COLUMN contacts.subscription_status_sms IS 'SMS subscription status';
COMMENT ON COLUMN contacts.source IS 'Original source of the contact';
COMMENT ON COLUMN contacts.site_source IS 'Website source of the contact';
COMMENT ON COLUMN contacts.sub_source IS 'Sub-source of the contact';
COMMENT ON COLUMN contacts.buyer_preference IS 'Contact''s preferred communication method';
COMMENT ON COLUMN contacts.birthday IS 'Contact''s birthday';
COMMENT ON COLUMN contacts.latest_interaction IS 'Date of last interaction with the contact';
COMMENT ON COLUMN contacts.tags IS 'Array of tags associated with the contact';
COMMENT ON COLUMN contacts.created_at IS 'Timestamp when the contact was created';
COMMENT ON COLUMN contacts.updated_at IS 'Timestamp when the contact was last updated'; 