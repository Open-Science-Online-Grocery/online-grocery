import React from 'react'
import CartDropdownContainer from './components/cart-dropdown/cart-dropdown-container'
import ProductGridContainer from './components/product-grid/product-grid-container'
var path = require('path')

class SearchPage extends React.Component{
  constructor(props) {
          super(props);
  }
  componentDidMount(){
  }
  render(){
    return(
    <div>
        <CartDropdownContainer/>
        <img className='logo-style' src={`${path.join(__dirname, 'images/howesgrocerybanner.png')}`}/>
        <div className= 'title'> Search Results: </div>
        <ProductGridContainer />
    </div>
    )
  }
}
export default SearchPage
