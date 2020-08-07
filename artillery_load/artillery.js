module.exports = { getData : getData };

var destination = require('./destination.json');

// randomly chooses a destination (city, country) and generates to and from dates
function getData(context, events, done) {
    // destination
    var i = Math.floor(Math.random() * 181);
    var city = destination[i].city.toLowerCase().replace(" ", "-");
    context.vars['city'] = city;
    var country = destination[i].country.toLowerCase().replace(" ", "-");
    context.vars['country'] = country;
    // dates
    var from = new Date();
    from.setDate(from.getDate() + 1); 
    context.vars['fromDay'] = String(from.getDate()).padStart(2, '0');
    context.vars['fromMonth'] = String(from.getMonth() + 1).padStart(2, '0'); //January is 0!
    context.vars['fromYear'] = from.getFullYear();
    var to = new Date();
    to.setDate(from.getDate() + 7); 
    context.vars['toDay'] = String(to.getDate()).padStart(2, '0');
    context.vars['toMonth'] = String(to.getMonth() + 1).padStart(2, '0'); //January is 0!
    context.vars['toYear'] = to.getFullYear();
    return done();
}