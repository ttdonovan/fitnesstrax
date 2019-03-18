import React from 'react'

const setsFieldStyle = {display: "inline", padding: 1, margin: 0};

export class SetRepRow extends React.Component {
    render () {
        return <tr key={this.props.data.date}><td>{this.props.data.activity}</td><td><input className="form-control" style={setsFieldStyle} value={intercalate(this.props.data.sets, ' ')} /></td><td>{sum(this.props.data.sets)}</td></tr> 
    }

}



