export const categoryActionTypes = {
    SET_CATEGORY: `SET_CATEGORY`,
    SET_PRODUCTS: `SET_PRODUCTS`,
    SET_CATEGORIES: `SET_CATEGORIES`,
    SET_SUBCATEGORIES: `SET_SUBCATEGORIES`,

}

function setCategory(category, subcategory) {
    return {
        type: categoryActionTypes.SET_CATEGORY,
        category: category,
        subcategory: subcategory
    }
}

function setProducts(products) {
    return {
        type: categoryActionTypes.SET_PRODUCTS,
        products: products
    }
}

function setCategories(categories) {
    return {
        type: categoryActionTypes.SET_CATEGORIES,
        categories: categories
    }
}

function setSubcategories(subcategories) {
    return {
        type: categoryActionTypes.SET_SUBCATEGORIES,
        subcategories: subcategories
    }
}

export const categoryActionCreators = {
    setCategory,
    setProducts,
    setCategories,
    setSubcategories
}
