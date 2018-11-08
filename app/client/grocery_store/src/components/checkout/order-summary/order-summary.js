import React from 'react'
import './order-summary.scss'
import axios from 'axios';
export default class OrderSummary extends React.Component{


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
    clearCart() {
        this.props.handleClearCart()
        this.props.cart.items.forEach((item) =>{
          axios.post('/user', {
            sessionID:this.props.sessionID,
            actionType: "checkout",
            product: item.name,
            quantity: item.quantity
          })
          .then(response => {
            console.log(response)
          })

        })
    }
    listCartItems() {
        const listedItems = this.props.cart.items.map((item) => {
            console.log(item)
            return (
                <div className='order-item'>
                    <img src={item.imageSrc} className='order-item-image'/>
                    <div className='order-item-name'>{item.name} </div>
                    <span className='order-item-detail'>
                        {item.quantity > 1 &&
                        <span className='order-item-quantity'>{item.quantity} x </span>
                        }
                        <span className='order-item-price'>${parseFloat(Math.round(item.price * 100) / 100).toFixed(2)} </span>
                    </span>
                    <span onClick={() => this.removeFromCart(item)} className='order-delete-item'>X</span>
                </div>
            )
        })
        listedItems.push(
            <div className='order-item bold'>Subtotal
                <span className='order-item-detail normal-height'>
                    <span className='order-item-price bold'>${parseFloat(Math.round(this.props.cart.price * 100) / 100).toFixed(2)}</span>
                </span>
            </div>
        )
        listedItems.push(
            <div className='order-item bold'>Sales tax (7.5%)
                <span className='order-item-detail normal-height'>
                    <span className='order-item-price'>${parseFloat(Math.round(this.props.cart.price * 100) * 0.075 / 100).toFixed(2)}</span>
                </span>
            </div>
        )
        listedItems.push(
            <div className='order-item bold order-final-total'>Total
                <span className='order-item-detail' >${parseFloat(Math.round(this.props.cart.price * 100) * 1.075 / 100).toFixed(2)}</span>
            </div>
        )
        return listedItems
    }

    render() {
        return(
            <div className='order-summary'>
                <div className='order-header-bar bold'>
                    Review Order
                </div>
                {this.listCartItems()}
                <button type='submit' onClick={() => {this.clearCart()}} className='checkout-button bold'>Complete Order</button>
            </div>
        )
    }
}
