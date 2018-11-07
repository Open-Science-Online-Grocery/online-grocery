import React from 'react'
import './thank-you-page.scss'
import { Link } from 'react-router-dom'

var path = require('path')

const staticText = {
    header: "Thank You For Your Order!",
    subheader: "We appreciate all of your feedback on your shopping experience today! The following is the code to" +
    " continue your Qualtrics survey:",
    code: "HHLMMSP"
}

export default class ThankYouPage extends React.Component {

    render() {
        return (
            <div className='thank-you-page'>
                <img className='logo-style' src={`${path.join(__dirname, 'images/howesgrocerybanner.png')}`}/>
                <div className='thank-you-header'>{staticText.header}</div>
                <div className='thank-you-subheader'>{staticText.subheader}</div>
                <div className='thank-you-subheader bold'>{staticText.code}</div>
                <Link to='/' className='no-underline'>
                    <button className='back-to-shopping-button bold'>Back to Shopping</button>
                </Link>
            </div>
        )
    }
}