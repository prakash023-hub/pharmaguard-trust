use odra::prelude::*;

#[odra::module]
pub struct ComplianceAttestation {
    lookup_count: Var<u32>,
}

#[odra::module]
impl ComplianceAttestation {
    pub fn init(&mut self) {
        self.lookup_count.set(0);
    }

    /// Records one clinical lookup attestation (count only — hashes stay off-chain).
    pub fn log_attestation(&mut self) {
        self.lookup_count.set(self.lookup_count() + 1);
    }

    pub fn lookup_count(&self) -> u32 {
        self.lookup_count.get_or_default()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use odra::host::{Deployer, NoArgs};

    #[test]
    fn logs_attestation() {
        let env = odra_test::env();
        let mut contract = ComplianceAttestation::deploy(&env, NoArgs);
        contract.log_attestation();
        assert_eq!(contract.lookup_count(), 1);
    }
}
