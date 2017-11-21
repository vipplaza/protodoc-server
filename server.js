const Hapi = require('hapi');
const Vision = require('vision');
const Handlebars = require('handlebars');

const server = Hapi.Server({ port: 3000 });

const rootHandler = (request, h) => {
    return h.view('index', {
        title: 'Protobuf Docs' + request.server.version
    });
};

const provision = async () => {

    await server.register(Vision);

    server.views({
        engines: { html: Handlebars },
        isCached: false,
        relativeTo: __dirname,
        path: 'doc'
    });

    server.route({ method: 'GET', path: '/documentation', handler: rootHandler });

    await server.start();
    console.log('Server running at:', server.info.uri);
};

provision();
