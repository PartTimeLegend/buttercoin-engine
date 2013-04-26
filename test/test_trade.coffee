BD = require('bigdecimal')
Q = require("q")

logger = require('../lib/logger')

operations = require('../lib/operations')
ProcessingChainEntrance = require('../lib/processingchainentrance')
TradeEngine = require('../lib/trade_engine')
Journal = require('../lib/journal')

kTestFilename = 'test.log'


describe 'TradeEngine', ->
  beforeEach =>
    TestHelper.remove_log(kTestFilename)

  afterEach =>
    TestHelper.remove_log(kTestFilename)

  it 'can perform deposit', (finish) ->
    deferred = Q.defer()
    deferred.resolve(undefined)

    replicationStub =
      start: sinon.stub()
      send: sinon.stub().returns(deferred.promise)

    pce = new ProcessingChainEntrance(new TradeEngine(),
                                      new Journal(kTestFilename),
                                      replicationStub)
    pce.start().then ->
      logger.info('Started PCE')
      pce.forward_operation
        kind: operations.ADD_DEPOSIT
        account: 'Peter'
        currency: 'USD'
        amount: 200.0
      .then =>
        finish()
    .done()
