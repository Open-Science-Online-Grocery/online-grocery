import React from 'react'
import './online-grocery.scss'
import {
  withRouter
} from "react-router-dom";

class SessionIDPage extends React.Component{
  constructor(props) {
    super(props);
    this.state = {value: ''};

    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }
  handleChange(event) {
    this.setState({value: event.target.value});
  }
  handleSubmit(event){
    event.preventDefault()
    if (this.state.value != '') {
      this.props.handleSetUser(this.state.value)
      this.props.history.push({
        pathname: '/home'
      })
    }

  }
  render(){
    const staticText = "Please enter your session ID given to you by Qualtrics:"
    return(
            <div className= "form-container">
            <form className="form-style" onSubmit= {this.handleSubmit}>
              <div className="form-prompt">{staticText}</div>
              <input className="form-input" type='text' value={this.state.value} onChange={this.handleChange} />
              <input type="submit" value="Submit" />
            </form>
            </div>
      )
  }
}
export default withRouter(SessionIDPage)
