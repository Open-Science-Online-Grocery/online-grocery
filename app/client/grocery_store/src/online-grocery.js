import React from 'react'
import ProductGridContainer from './components/product-grid/product-grid-container'
import TopNav from './components/top-nav/top-nav'
import CartDropdownContainer from './components/cart-dropdown/cart-dropdown-container'
import './online-grocery.scss'

var path = require('path')

class HomePage extends React.Component{
  render(){
      return(
        <div>
            <CartDropdownContainer/>
            <img className='logo-style' src={`${path.join(__dirname, 'images/howesgrocerybanner.png')}`}/>
            <TopNav {...this.props}/>
            <ProductGridContainer/>
        </div>
      )
  }
}
export default HomePage
