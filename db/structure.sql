SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_admin_comments (
    id bigint NOT NULL,
    namespace character varying,
    body text,
    resource_type character varying,
    resource_id bigint,
    author_type character varying,
    author_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_admin_comments_id_seq OWNED BY public.active_admin_comments.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_users.id;


--
-- Name: api_token_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_token_requests (
    id bigint NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    user_id bigint NOT NULL,
    note text,
    admin_note text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: api_token_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.api_token_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_token_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.api_token_requests_id_seq OWNED BY public.api_token_requests.id;


--
-- Name: api_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_tokens (
    id bigint NOT NULL,
    uuid character varying NOT NULL,
    user_id bigint,
    api_token_request_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: api_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.api_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.api_tokens_id_seq OWNED BY public.api_tokens.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: cart_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_items (
    id bigint NOT NULL,
    product_id bigint,
    temp_cart_id bigint,
    quantity integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cart_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;


--
-- Name: cart_summary_labels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cart_summary_labels (
    id bigint NOT NULL,
    name character varying,
    image character varying,
    built_in boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cart_summary_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cart_summary_labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cart_summary_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cart_summary_labels_id_seq OWNED BY public.cart_summary_labels.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: condition_cart_summary_labels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.condition_cart_summary_labels (
    id bigint NOT NULL,
    condition_id bigint,
    cart_summary_label_id bigint,
    equation_tokens text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    always_show boolean DEFAULT true
);


--
-- Name: condition_cart_summary_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.condition_cart_summary_labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: condition_cart_summary_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.condition_cart_summary_labels_id_seq OWNED BY public.condition_cart_summary_labels.id;


--
-- Name: condition_labels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.condition_labels (
    id bigint NOT NULL,
    condition_id bigint,
    label_id bigint,
    "position" character varying,
    size integer,
    equation_tokens text,
    always_show boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    tooltip_text character varying
);


--
-- Name: condition_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.condition_labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: condition_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.condition_labels_id_seq OWNED BY public.condition_labels.id;


--
-- Name: condition_product_sort_fields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.condition_product_sort_fields (
    id bigint NOT NULL,
    condition_id bigint,
    product_sort_field_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: condition_product_sort_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.condition_product_sort_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: condition_product_sort_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.condition_product_sort_fields_id_seq OWNED BY public.condition_product_sort_fields.id;


--
-- Name: conditions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conditions (
    id bigint NOT NULL,
    name character varying NOT NULL,
    experiment_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    uuid character varying NOT NULL,
    nutrition_styles text,
    default_sort_field_id bigint,
    default_sort_order character varying,
    sort_equation_tokens text,
    filter_by_custom_categories boolean DEFAULT false NOT NULL,
    show_price_total boolean DEFAULT true NOT NULL,
    food_count_format character varying,
    only_add_from_detail_page boolean DEFAULT false,
    nutrition_equation_tokens text,
    minimum_spend numeric(10,2),
    maximum_spend numeric(10,2),
    may_add_to_cart_by_dollar_amount boolean DEFAULT false,
    show_guiding_stars boolean DEFAULT true,
    qualtrics_code character varying,
    sort_type character varying,
    show_products_by_subcategory boolean DEFAULT true,
    allow_searching boolean DEFAULT true,
    show_custom_attribute_on_product boolean DEFAULT false NOT NULL,
    show_custom_attribute_on_checkout boolean DEFAULT false NOT NULL,
    custom_attribute_units character varying,
    custom_attribute_name character varying,
    display_old_price boolean
);


--
-- Name: conditions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conditions_id_seq OWNED BY public.conditions.id;


--
-- Name: config_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.config_files (
    id bigint NOT NULL,
    file character varying,
    condition_id bigint,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying
);


--
-- Name: config_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.config_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: config_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.config_files_id_seq OWNED BY public.config_files.id;


--
-- Name: custom_product_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_product_attributes (
    id bigint NOT NULL,
    condition_id bigint,
    product_attribute_csv_file_id bigint,
    product_id bigint,
    custom_attribute_amount character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: custom_product_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_product_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_product_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_product_attributes_id_seq OWNED BY public.custom_product_attributes.id;


--
-- Name: custom_product_prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_product_prices (
    id bigint NOT NULL,
    condition_id bigint,
    product_price_csv_file_id bigint,
    product_id bigint,
    new_price numeric(64,12),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: custom_product_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_product_prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_product_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_product_prices_id_seq OWNED BY public.custom_product_prices.id;


--
-- Name: custom_sortings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_sortings (
    id bigint NOT NULL,
    session_identifier character varying,
    condition_id bigint,
    sort_file_id bigint,
    product_id bigint,
    sort_order integer
);


--
-- Name: custom_sortings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_sortings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_sortings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_sortings_id_seq OWNED BY public.custom_sortings.id;


--
-- Name: experiments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.experiments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: participant_actions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.participant_actions (
    id bigint NOT NULL,
    session_identifier character varying,
    condition_id bigint,
    action_type character varying,
    quantity integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    product_id bigint,
    serial_position integer,
    detail character varying,
    performed_at timestamp without time zone,
    frontend_id character varying
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying,
    size character varying,
    description text,
    image_src text,
    serving_size character varying,
    servings character varying,
    calories_from_fat integer,
    calories integer,
    total_fat numeric(10,1),
    saturated_fat numeric(10,1),
    trans_fat numeric(10,1),
    poly_fat numeric(10,1),
    mono_fat numeric(10,1),
    sodium integer,
    potassium integer,
    carbs integer,
    fiber integer,
    sugar integer,
    protein integer,
    vitamins text,
    ingredients text,
    allergens text,
    price numeric(64,12),
    category_id integer,
    subcategory_id integer,
    starpoints integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    cholesterol numeric(6,2),
    subsubcategory_id bigint,
    aws_image_url character varying,
    serving_size_grams numeric(6,1),
    caloric_density numeric(6,1)
);


--
-- Name: experiment_results; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.experiment_results AS
 SELECT experiments.id AS experiment_id,
    experiments.name AS experiment_name,
    conditions.name AS condition_name,
    participant_actions.session_identifier,
    participant_actions.action_type,
    participant_actions.product_id,
    products.name AS product_name,
    participant_actions.quantity,
    participant_actions.serial_position,
    participant_actions.detail,
    participant_actions.performed_at
   FROM (((public.experiments
     JOIN public.conditions ON ((conditions.experiment_id = experiments.id)))
     JOIN public.participant_actions ON ((participant_actions.condition_id = conditions.id)))
     LEFT JOIN public.products ON ((participant_actions.product_id = products.id)));


--
-- Name: experiments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.experiments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: experiments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.experiments_id_seq OWNED BY public.experiments.id;


--
-- Name: labels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.labels (
    id bigint NOT NULL,
    name character varying,
    built_in boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image character varying
);


--
-- Name: labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.labels_id_seq OWNED BY public.labels.id;


--
-- Name: participant_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.participant_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participant_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.participant_actions_id_seq OWNED BY public.participant_actions.id;


--
-- Name: product_attribute_csv_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_attribute_csv_files (
    id bigint NOT NULL,
    csv_file character varying,
    condition_id bigint,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_attribute_csv_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_attribute_csv_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_attribute_csv_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_attribute_csv_files_id_seq OWNED BY public.product_attribute_csv_files.id;


--
-- Name: product_price_csv_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_price_csv_files (
    id bigint NOT NULL,
    csv_file character varying,
    condition_id bigint,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_price_csv_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_price_csv_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_price_csv_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_price_csv_files_id_seq OWNED BY public.product_price_csv_files.id;


--
-- Name: product_sort_fields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_sort_fields (
    id bigint NOT NULL,
    name character varying,
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_sort_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_sort_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_sort_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_sort_fields_id_seq OWNED BY public.product_sort_fields.id;


--
-- Name: product_suggestions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_suggestions (
    id bigint NOT NULL,
    product_id bigint,
    add_on_product_id bigint,
    suggestion_csv_file_id bigint,
    condition_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_suggestions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_suggestions_id_seq OWNED BY public.product_suggestions.id;


--
-- Name: product_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_tags (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    tag_id bigint NOT NULL,
    subtag_id bigint,
    condition_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_tags_id_seq OWNED BY public.product_tags.id;


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: subcategories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subcategories (
    id bigint NOT NULL,
    category_id integer,
    display_order integer,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subcategories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subcategories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subcategories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subcategories_id_seq OWNED BY public.subcategories.id;


--
-- Name: subcategory_exclusions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subcategory_exclusions (
    id bigint NOT NULL,
    condition_id bigint,
    subcategory_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subcategory_exclusions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subcategory_exclusions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subcategory_exclusions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subcategory_exclusions_id_seq OWNED BY public.subcategory_exclusions.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id bigint NOT NULL,
    paypal_subscription_id character varying,
    user_id bigint,
    start_date timestamp without time zone,
    perpetual_membership boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: subsubcategories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subsubcategories (
    id bigint NOT NULL,
    subcategory_id bigint,
    display_order integer,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subsubcategories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subsubcategories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subsubcategories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subsubcategories_id_seq OWNED BY public.subsubcategories.id;


--
-- Name: subtags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subtags (
    id bigint NOT NULL,
    tag_id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subtags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subtags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subtags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subtags_id_seq OWNED BY public.subtags.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: temp_carts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.temp_carts (
    id bigint NOT NULL,
    condition_identifier character varying,
    session_id character varying,
    pop_up_message character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: temp_carts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.temp_carts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.temp_carts_id_seq OWNED BY public.temp_carts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name character varying,
    last_name character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: active_admin_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments ALTER COLUMN id SET DEFAULT nextval('public.active_admin_comments_id_seq'::regclass);


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- Name: api_token_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_token_requests ALTER COLUMN id SET DEFAULT nextval('public.api_token_requests_id_seq'::regclass);


--
-- Name: api_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_tokens ALTER COLUMN id SET DEFAULT nextval('public.api_tokens_id_seq'::regclass);


--
-- Name: cart_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);


--
-- Name: cart_summary_labels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_summary_labels ALTER COLUMN id SET DEFAULT nextval('public.cart_summary_labels_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: condition_cart_summary_labels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.condition_cart_summary_labels ALTER COLUMN id SET DEFAULT nextval('public.condition_cart_summary_labels_id_seq'::regclass);


--
-- Name: condition_labels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.condition_labels ALTER COLUMN id SET DEFAULT nextval('public.condition_labels_id_seq'::regclass);


--
-- Name: condition_product_sort_fields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.condition_product_sort_fields ALTER COLUMN id SET DEFAULT nextval('public.condition_product_sort_fields_id_seq'::regclass);


--
-- Name: conditions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conditions ALTER COLUMN id SET DEFAULT nextval('public.conditions_id_seq'::regclass);


--
-- Name: config_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.config_files ALTER COLUMN id SET DEFAULT nextval('public.config_files_id_seq'::regclass);


--
-- Name: custom_product_attributes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_product_attributes ALTER COLUMN id SET DEFAULT nextval('public.custom_product_attributes_id_seq'::regclass);


--
-- Name: custom_product_prices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_product_prices ALTER COLUMN id SET DEFAULT nextval('public.custom_product_prices_id_seq'::regclass);


--
-- Name: custom_sortings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_sortings ALTER COLUMN id SET DEFAULT nextval('public.custom_sortings_id_seq'::regclass);


--
-- Name: experiments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiments ALTER COLUMN id SET DEFAULT nextval('public.experiments_id_seq'::regclass);


--
-- Name: labels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.labels ALTER COLUMN id SET DEFAULT nextval('public.labels_id_seq'::regclass);


--
-- Name: participant_actions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participant_actions ALTER COLUMN id SET DEFAULT nextval('public.participant_actions_id_seq'::regclass);


--
-- Name: product_attribute_csv_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_attribute_csv_files ALTER COLUMN id SET DEFAULT nextval('public.product_attribute_csv_files_id_seq'::regclass);


--
-- Name: product_price_csv_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_price_csv_files ALTER COLUMN id SET DEFAULT nextval('public.product_price_csv_files_id_seq'::regclass);


--
-- Name: product_sort_fields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sort_fields ALTER COLUMN id SET DEFAULT nextval('public.product_sort_fields_id_seq'::regclass);


--
-- Name: product_suggestions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_suggestions ALTER COLUMN id SET DEFAULT nextval('public.product_suggestions_id_seq'::regclass);


--
-- Name: product_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_tags ALTER COLUMN id SET DEFAULT nextval('public.product_tags_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: subcategories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategories ALTER COLUMN id SET DEFAULT nextval('public.subcategories_id_seq'::regclass);


--
-- Name: subcategory_exclusions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategory_exclusions ALTER COLUMN id SET DEFAULT nextval('public.subcategory_exclusions_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: subsubcategories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subsubcategories ALTER COLUMN id SET DEFAULT nextval('public.subsubcategories_id_seq'::regclass);


--
-- Name: subtags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subtags ALTER COLUMN id SET DEFAULT nextval('public.subtags_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: temp_carts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temp_carts ALTER COLUMN id SET DEFAULT nextval('public.temp_carts_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: active_admin_comments active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: api_token_requests api_token_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_token_requests
    ADD CONSTRAINT api_token_requests_pkey PRIMARY KEY (id);


--
-- Name: api_tokens api_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_tokens
    ADD CONSTRAINT api_tokens_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: cart_summary_labels cart_summary_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cart_summary_labels
    ADD CONSTRAINT cart_summary_labels_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: condition_cart_summary_labels condition_cart_summary_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.condition_cart_summary_labels
    ADD CONSTRAINT condition_cart_summary_labels_pkey PRIMARY KEY (id);


--
-- Name: condition_labels condition_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.condition_labels
    ADD CONSTRAINT condition_labels_pkey PRIMARY KEY (id);


--
-- Name: condition_product_sort_fields condition_product_sort_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.condition_product_sort_fields
    ADD CONSTRAINT condition_product_sort_fields_pkey PRIMARY KEY (id);


--
-- Name: conditions conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conditions
    ADD CONSTRAINT conditions_pkey PRIMARY KEY (id);


--
-- Name: config_files config_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.config_files
    ADD CONSTRAINT config_files_pkey PRIMARY KEY (id);


--
-- Name: custom_product_attributes custom_product_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_product_attributes
    ADD CONSTRAINT custom_product_attributes_pkey PRIMARY KEY (id);


--
-- Name: custom_product_prices custom_product_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_product_prices
    ADD CONSTRAINT custom_product_prices_pkey PRIMARY KEY (id);


--
-- Name: custom_sortings custom_sortings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_sortings
    ADD CONSTRAINT custom_sortings_pkey PRIMARY KEY (id);


--
-- Name: experiments experiments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.experiments
    ADD CONSTRAINT experiments_pkey PRIMARY KEY (id);


--
-- Name: labels labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.labels
    ADD CONSTRAINT labels_pkey PRIMARY KEY (id);


--
-- Name: participant_actions participant_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participant_actions
    ADD CONSTRAINT participant_actions_pkey PRIMARY KEY (id);


--
-- Name: product_attribute_csv_files product_attribute_csv_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_attribute_csv_files
    ADD CONSTRAINT product_attribute_csv_files_pkey PRIMARY KEY (id);


--
-- Name: product_price_csv_files product_price_csv_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_price_csv_files
    ADD CONSTRAINT product_price_csv_files_pkey PRIMARY KEY (id);


--
-- Name: product_sort_fields product_sort_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sort_fields
    ADD CONSTRAINT product_sort_fields_pkey PRIMARY KEY (id);


--
-- Name: product_suggestions product_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_suggestions
    ADD CONSTRAINT product_suggestions_pkey PRIMARY KEY (id);


--
-- Name: product_tags product_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_tags
    ADD CONSTRAINT product_tags_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: subcategories subcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategories
    ADD CONSTRAINT subcategories_pkey PRIMARY KEY (id);


--
-- Name: subcategory_exclusions subcategory_exclusions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategory_exclusions
    ADD CONSTRAINT subcategory_exclusions_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: subsubcategories subsubcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subsubcategories
    ADD CONSTRAINT subsubcategories_pkey PRIMARY KEY (id);


--
-- Name: subtags subtags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subtags
    ADD CONSTRAINT subtags_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: temp_carts temp_carts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.temp_carts
    ADD CONSTRAINT temp_carts_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_active_admin_comments_on_author; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_author ON public.active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_namespace ON public.active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_resource ON public.active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_email ON public.admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON public.admin_users USING btree (reset_password_token);


--
-- Name: index_api_token_requests_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_api_token_requests_on_user_id ON public.api_token_requests USING btree (user_id);


--
-- Name: index_api_tokens_on_api_token_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_api_tokens_on_api_token_request_id ON public.api_tokens USING btree (api_token_request_id);


--
-- Name: index_api_tokens_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_api_tokens_on_user_id ON public.api_tokens USING btree (user_id);


--
-- Name: index_cart_items_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cart_items_on_product_id ON public.cart_items USING btree (product_id);


--
-- Name: index_cart_items_on_temp_cart_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cart_items_on_temp_cart_id ON public.cart_items USING btree (temp_cart_id);


--
-- Name: index_condition_cart_summary_labels_on_cart_summary_label_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_condition_cart_summary_labels_on_cart_summary_label_id ON public.condition_cart_summary_labels USING btree (cart_summary_label_id);


--
-- Name: index_condition_cart_summary_labels_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_condition_cart_summary_labels_on_condition_id ON public.condition_cart_summary_labels USING btree (condition_id);


--
-- Name: index_condition_labels_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_condition_labels_on_condition_id ON public.condition_labels USING btree (condition_id);


--
-- Name: index_condition_labels_on_label_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_condition_labels_on_label_id ON public.condition_labels USING btree (label_id);


--
-- Name: index_condition_product_sort_fields_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_condition_product_sort_fields_on_condition_id ON public.condition_product_sort_fields USING btree (condition_id);


--
-- Name: index_condition_product_sort_fields_on_product_sort_field_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_condition_product_sort_fields_on_product_sort_field_id ON public.condition_product_sort_fields USING btree (product_sort_field_id);


--
-- Name: index_conditions_on_default_sort_field_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_conditions_on_default_sort_field_id ON public.conditions USING btree (default_sort_field_id);


--
-- Name: index_conditions_on_experiment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_conditions_on_experiment_id ON public.conditions USING btree (experiment_id);


--
-- Name: index_config_files_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_config_files_on_condition_id ON public.config_files USING btree (condition_id);


--
-- Name: index_config_files_on_id_and_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_config_files_on_id_and_type ON public.config_files USING btree (id, type);


--
-- Name: index_custom_product_attributes_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_product_attributes_on_condition_id ON public.custom_product_attributes USING btree (condition_id);


--
-- Name: index_custom_product_attributes_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_product_attributes_on_product_id ON public.custom_product_attributes USING btree (product_id);


--
-- Name: index_custom_product_prices_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_product_prices_on_condition_id ON public.custom_product_prices USING btree (condition_id);


--
-- Name: index_custom_product_prices_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_product_prices_on_product_id ON public.custom_product_prices USING btree (product_id);


--
-- Name: index_custom_product_prices_on_product_price_csv_file_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_product_prices_on_product_price_csv_file_id ON public.custom_product_prices USING btree (product_price_csv_file_id);


--
-- Name: index_custom_sortings_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_sortings_on_condition_id ON public.custom_sortings USING btree (condition_id);


--
-- Name: index_custom_sortings_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_sortings_on_product_id ON public.custom_sortings USING btree (product_id);


--
-- Name: index_custom_sortings_on_session_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_sortings_on_session_identifier ON public.custom_sortings USING btree (session_identifier);


--
-- Name: index_custom_sortings_on_sort_file_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_sortings_on_sort_file_id ON public.custom_sortings USING btree (sort_file_id);


--
-- Name: index_custom_sortings_on_sort_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_sortings_on_sort_order ON public.custom_sortings USING btree (sort_order);


--
-- Name: index_experiments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_experiments_on_user_id ON public.experiments USING btree (user_id);


--
-- Name: index_participant_actions_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participant_actions_on_condition_id ON public.participant_actions USING btree (condition_id);


--
-- Name: index_participant_actions_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participant_actions_on_product_id ON public.participant_actions USING btree (product_id);


--
-- Name: index_product_attribute_csv_files_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_attribute_csv_files_on_condition_id ON public.product_attribute_csv_files USING btree (condition_id);


--
-- Name: index_product_price_csv_files_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_price_csv_files_on_condition_id ON public.product_price_csv_files USING btree (condition_id);


--
-- Name: index_product_suggestions_on_add_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_suggestions_on_add_on_product_id ON public.product_suggestions USING btree (add_on_product_id);


--
-- Name: index_product_suggestions_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_suggestions_on_condition_id ON public.product_suggestions USING btree (condition_id);


--
-- Name: index_product_suggestions_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_suggestions_on_product_id ON public.product_suggestions USING btree (product_id);


--
-- Name: index_product_suggestions_on_suggestion_csv_file_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_suggestions_on_suggestion_csv_file_id ON public.product_suggestions USING btree (suggestion_csv_file_id);


--
-- Name: index_product_tags_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_tags_on_condition_id ON public.product_tags USING btree (condition_id);


--
-- Name: index_product_tags_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_tags_on_product_id ON public.product_tags USING btree (product_id);


--
-- Name: index_product_tags_on_subtag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_tags_on_subtag_id ON public.product_tags USING btree (subtag_id);


--
-- Name: index_product_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_tags_on_tag_id ON public.product_tags USING btree (tag_id);


--
-- Name: index_products_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_category_id ON public.products USING btree (category_id);


--
-- Name: index_products_on_subcategory_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_subcategory_id ON public.products USING btree (subcategory_id);


--
-- Name: index_products_on_subsubcategory_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_subsubcategory_id ON public.products USING btree (subsubcategory_id);


--
-- Name: index_subcategories_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subcategories_on_category_id ON public.subcategories USING btree (category_id);


--
-- Name: index_subcategory_exclusions_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subcategory_exclusions_on_condition_id ON public.subcategory_exclusions USING btree (condition_id);


--
-- Name: index_subcategory_exclusions_on_condition_id_and_subcategory_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subcategory_exclusions_on_condition_id_and_subcategory_id ON public.subcategory_exclusions USING btree (condition_id, subcategory_id);


--
-- Name: index_subcategory_exclusions_on_subcategory_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subcategory_exclusions_on_subcategory_id ON public.subcategory_exclusions USING btree (subcategory_id);


--
-- Name: index_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_user_id ON public.subscriptions USING btree (user_id);


--
-- Name: index_subsubcategories_on_subcategory_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subsubcategories_on_subcategory_id ON public.subsubcategories USING btree (subcategory_id);


--
-- Name: index_subtags_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subtags_on_tag_id ON public.subtags USING btree (tag_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: api_token_requests fk_rails_688226dfe1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_token_requests
    ADD CONSTRAINT fk_rails_688226dfe1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180919181445'),
('20180919182806'),
('20180920131524'),
('20180924160613'),
('20181029180040'),
('20181101134850'),
('20181101140714'),
('20181101144453'),
('20181101192221'),
('20181101195927'),
('20181101201931'),
('20181102153742'),
('20181105145354'),
('20181106180529'),
('20181107141053'),
('20181107212757'),
('20181108190400'),
('20181108190901'),
('20181108205830'),
('20181109184849'),
('20181109192449'),
('20181111220655'),
('20181112171539'),
('20181112183838'),
('20181114142831'),
('20181114144446'),
('20181119164647'),
('20181126022808'),
('20181127155504'),
('20181127212210'),
('20181130211619'),
('20181211164301'),
('20181211184522'),
('20190221200154'),
('20190227175452'),
('20190227180805'),
('20190306151626'),
('20190307193245'),
('20190319133936'),
('20190822140435'),
('20190822140828'),
('20210204170847'),
('20210208152732'),
('20210210181943'),
('20210217174649'),
('20210223151548'),
('20210310181245'),
('20210930175208'),
('20211001155043'),
('20211005133810'),
('20211006163426'),
('20211007184814'),
('20211101155624'),
('20211101190836'),
('20211221205528'),
('20211222160023'),
('20220114152549'),
('20221229170233'),
('20221229172827'),
('20221229180249'),
('20230102153452'),
('20230119135913'),
('20230119140755'),
('20230123192926'),
('20230208163854'),
('20230410123410'),
('20230413155749'),
('20240107003453'),
('20240107003456'),
('20240108030728'),
('20240108031219'),
('20240109221053');


