import Card from "components/common/Card"

const AccountCard = ({ children }) => (
  <Card
    bg={"black"}
    // boxShadow="none"
    // overflow="visible"
    borderColor="yellow"
    borderWidth="20"
  >
    {children}
  </Card>
)

export default AccountCard
