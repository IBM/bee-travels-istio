module.exports = { getDestination : getDestination };

var destination = require('./destination.json');

// randomly chooses a destination (city, country)
function getDestination(context, events, done) {
    var i = Math.floor(Math.random() * 181);
    var city = destination[i].city.toLowerCase().replace(" ", "-");
    context.vars['city'] = city;
    var country = destination[i].country.toLowerCase().replace(" ", "-");
    context.vars['country'] = country;
    return done();
}
