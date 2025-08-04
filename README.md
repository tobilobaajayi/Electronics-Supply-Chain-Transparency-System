# Electronics Supply Chain Transparency System

A comprehensive blockchain-based system for tracking and verifying the entire lifecycle of electronic components, from sourcing to disposal.

## Overview

This system provides transparency and accountability across the electronics supply chain through five interconnected smart contracts:

1. **Component Origin Verification** - Records and verifies the source of electronic components
2. **Conflict Minerals Tracking** - Ensures components don't contain conflict minerals
3. **Environmental Compliance Monitoring** - Tracks environmental impact during production
4. **Recycling Program Verification** - Manages proper disposal and recycling
5. **Counterfeit Prevention** - Prevents unauthorized copies and ensures authenticity

## Features

### Component Origin Verification
- Register component manufacturers and suppliers
- Track component origins with detailed metadata
- Verify ethical sourcing practices
- Maintain supplier reputation scores

### Conflict Minerals Tracking
- Monitor 3TG minerals (Tin, Tantalum, Tungsten, Gold)
- Verify conflict-free sourcing
- Track mineral origins and certifications
- Generate compliance reports

### Environmental Compliance
- Monitor water usage, chemical discharge, and carbon emissions
- Set and track compliance thresholds
- Generate environmental impact reports
- Reward eco-friendly practices

### Recycling Program Verification
- Track electronic waste disposal
- Verify proper recycling processes
- Monitor recycling facility certifications
- Calculate recycling rates and impact

### Counterfeit Prevention
- Generate unique component identifiers
- Verify component authenticity
- Track component lifecycle
- Prevent unauthorized duplication

## Contract Architecture

Each contract operates independently while maintaining data integrity through consistent data structures and validation patterns.

### Data Types

- **Component**: Unique electronic component with origin and specifications
- **Supplier**: Registered manufacturer or supplier entity
- **Environmental Record**: Production environmental impact data
- **Recycling Record**: Waste disposal and recycling information
- **Authentication Token**: Unique identifier for counterfeit prevention

## Getting Started

### Prerequisites

- Clarinet CLI installed
- Node.js and npm for testing
- Stacks blockchain testnet access

### Installation

\`\`\`bash
git clone <repository-url>
cd electronics-supply-chain
npm install
clarinet check
\`\`\`

### Testing

\`\`\`bash
npm test
\`\`\`

### Deployment

\`\`\`bash
clarinet deploy --testnet
\`\`\`

## Usage Examples

### Register a Component
\`\`\`clarity
(contract-call? .component-origin register-component
"CHIP001"
"Intel Corporation"
"Processor"
"USA")
\`\`\`

### Verify Conflict-Free Status
\`\`\`clarity
(contract-call? .conflict-minerals verify-conflict-free
"CHIP001"
(list "TIN" "TANTALUM"))
\`\`\`

### Record Environmental Data
\`\`\`clarity
(contract-call? .environmental-compliance record-environmental-data
"FAC001"
u1000
u50
u2000)
\`\`\`

## Security Considerations

- All contracts implement proper access controls
- Input validation prevents malicious data entry
- State changes are atomic and reversible where appropriate
- No cross-contract dependencies to minimize attack surface

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add comprehensive tests
4. Submit a pull request

## License

MIT License - see LICENSE file for details
