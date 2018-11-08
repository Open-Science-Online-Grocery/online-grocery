import React from 'react'
import './cart-dropdown.scss'
import { Link } from 'react-router-dom';
import axios from 'axios';
var path = require('path')

export default class CartDropdown extends React.Component {

    constructor(props) {
        super(props)

        this.state = {
            dropdownOpen: false,
            windowHeight: 0
        }

        this.openCloseDropdown = this.openCloseDropdown.bind(this)
        this.removeFromCart = this.removeFromCart.bind(this)
    }

    openCloseDropdown() {
        const currentlyOpen = this.state.dropdownOpen
        const height = window.innerHeight
        if (this.props.cart.items.length > 0) {
            this.setState({
                dropdownOpen: !currentlyOpen,
                windowHeight: height

            })
        }
    }

    removeFromCart(product) {
        this.props.handleRemoveFromCart(product)

        axios.post('/user', {
          sessionID: this.props.sessionID,
          actionType: "delete",
          product: product.name,
          quantity: product.quantity
        })
        .then(response => {
          console.log(response)
        })
    }

    render() {
        const cartItems = this.props.cart.items.map((item) => {
            return (
                <div className='cart-item'>
                    <span>{item.name} </span>
                    <span className='cart-detail'>
                        {item.quantity > 1 &&
                            <span className='cart-quantity'>{item.quantity} x </span>
                        }
                        <span className='cart-price'>${parseFloat(Math.round(item.price * 100) / 100).toFixed(2)} </span>
                    </span>
                    <span onClick={() => this.removeFromCart(item)} className='cart-delete-item'>X</span>
                </div>
            )
        })
        cartItems.unshift(

            <Link to={{ pathname: '/checkout'}} className='no-underline'>
                <div className='cart-item cart-checkout-bar'>Checkout
                    <span className='cart-detail' >Total: ${parseFloat(Math.round(this.props.cart.price * 100) / 100).toFixed(2)}</span>
                </div>
            </Link>
        )
        return (
            <div className='cart-button'>
                <img className='cart-image' src={`${path.join(__dirname, 'images/trolley-clipart-white.png')}`} onClick={this.openCloseDropdown}/>
                <div className='cart-count'>{this.props.cart.count}</div>
                {this.state.dropdownOpen && this.props.cart.items.length > 0 &&
                    <div style={{'maxHeight': this.state.windowHeight - 75}} className='cart-dropdown'>
                        {cartItems}
                    </div>
                }
            </div>
        )
    }
}
