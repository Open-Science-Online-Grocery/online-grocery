import React from 'react'
import TopNav from './components/top-nav/top-nav'
import ProductCardExpandedContainer from "./components/product-card-expanded/product-card-expanded-container";
import './online-grocery.scss';
import CartDropdownContainer from './components/cart-dropdown/cart-dropdown-container'

const tabNames = ['Produce', 'Deli & Dairy', 'Bread, Pasta & Rice', 'Packaged & Canned',
    'Condiments, Spreads & Sauces', 'Frozen Foods', 'Beverages'];

var view = "viewProduct"
var path = require('path')

class ProductViewPage extends React.Component{
  constructor(props) {
          super(props);
  }
  render(){
    const product = this.props.location.state.product
    const sessionId = this.props.location.state.sessionId
    return(
    <div>
        <CartDropdownContainer sessionId={sessionId}/>
        <img className='logo-style' src={require('./images/howesgrocerybanner.png')}/>
        <ProductCardExpandedContainer sessionId={sessionId} {...product}/>
    </div>
    )
  }
}
export default ProductViewPage
