const producer_name = process.argv.slice(1)[1];
const Eos = require('eosjs');
const config = {
    httpEndpoint: 'http://api.eosnewyork.io',
    chainId: 'aca376f206b8fc25a6ed44dbdc66547c36c6c33e3a119ffbeaef943642f0e906'
};
const eos = Eos(config);
let _gstate = null;
eos['getTableRows']({
    json: true, code: 'eosio', scope: 'eosio', table: 'global'
}).then((gstate) => {
    _gstate = gstate.rows[0];
    eos['getProducers']({json: true}).then((prods) => {
        for (const prod of prods.rows) {
            if (prod.owner === producer_name) {
                const producer_per_block_pay = (_gstate.perblock_bucket * prod.unpaid_blocks) / _gstate.total_unpaid_blocks;
                const producer_per_vote_pay = (_gstate.pervote_bucket * prod.total_votes) / _gstate.total_producer_vote_weight;
                const totalEOS = (producer_per_block_pay + producer_per_vote_pay) / 10000;
                console.log(totalEOS.toFixed(4) + " EOS ->> " + producer_name);
            }
        }
    });
});

