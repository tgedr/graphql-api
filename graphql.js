'use strict';

const { typeDefs, resolvers } = require('@tgedr/graphql-store-schema')
const { ApolloServer} = require('apollo-server-lambda');

const server = new ApolloServer({ typeDefs, resolvers });
exports.handler = server.createHandler();