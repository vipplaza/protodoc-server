const Hapi = require('hapi');
const Vision = require('vision');
const Inert = require('inert');
const Handlebars = require('handlebars');

const server = Hapi.Server({ port: 3000 });

const rootHandler = (request, h) => {
    return h.view('index', {
        title: 'Protobuf Docs' + request.server.version
    });
};
const jsHandler = (request, reply) => {
  return reply.file('./doc/js.zip')
};
const phpHandler = (request, reply) => {
  return reply.file('./doc/php.zip')
};

const provision = async () => {

    await server.register(Vision);
    await server.register(Inert);

    server.views({
        engines: { html: Handlebars },
        isCached: false,
        relativeTo: __dirname,
        path: 'doc'
    });

    server.route([
        { method: 'GET', path: '/documentation', handler: rootHandler },
        { method: 'GET', path: '/js', handler: jsHandler },
        { method: 'GET', path: '/php', handler: phpHandler },
    ]);

    await server.start();
    console.log('Server running at:', server.info.uri);
};

provision();
