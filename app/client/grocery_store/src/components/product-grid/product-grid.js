import React from 'react'
import './product-grid.scss'
import ProductCardContainer from '../product-card/product-card-container'

export default class ProductGrid extends React.Component {

    render() {
        let productCards = this.props.products.map((product,i) => {
            return (
                <div key={i} className='product-grid-item'>
                    <ProductCardContainer product={product}/>
                </div>
            )
        })
        return (
            <div>{productCards}</div>
        )
    }

}
